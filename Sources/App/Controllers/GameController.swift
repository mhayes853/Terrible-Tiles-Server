//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor

/// Controller for recieving and sending game data back to the client
class GameController: RouteCollection {
    private let scoresService: ScoresService
    private let gameStateService: GameStateService
    private var taskQueue = GameTaskQueue()
    
    init(_ scoresService: ScoresService, _ gameStateService: GameStateService) {
        self.scoresService = scoresService
        self.gameStateService = gameStateService
    }
    
    func boot(routes: RoutesBuilder) throws {
        let game = routes.grouped("game")
        game.webSocket("connect", onUpgrade: self.handleGameConnection)
    }
    
    private func handleGameConnection(req: Request, ws: WebSocket) async {
        do {
            let newState = try await self.gameStateService.createNew()
            try await ws.sendEncodable(newState.socketResponse)
            
            // TODO: Initialize Game Board and Queue Task to drop tiles periodically
            
            ws.onText(self.handleGameCommand)
        } catch {
            try? await ws.closeWithErrorResponse(
                gameErrorCode: .internalError,
                socketErrorCode: .unexpectedServerError
            )
        }
    }
    
    private func handleGameCommand(ws: WebSocket, text: String) async {
        do {
            let socketCommand = try self.decodeSocketCommand(text)
            let response = try await self.handleCommand(socketCommand)
            
            try await ws.sendEncodable(response)
        } catch is GameStateService.StateError {
            try? await ws.closeWithErrorResponse(gameErrorCode: .invalidStateKey)
        } catch let error as GameSocketCommand.CommandError {
            try? await ws.closeWithErrorResponse(gameErrorCode: error.errorCode)
        } catch {
            try? await ws.closeWithErrorResponse(
                gameErrorCode: .internalError,
                socketErrorCode: .unexpectedServerError
            )
        }
    }
    
    private func decodeSocketCommand(_ text: String) throws -> GameSocketCommand {
        guard let encodedCommand = text.data(using: .utf8) else {
            throw GameSocketCommand.CommandError(errorCode: .malformedCommand)
        }
        
        let decodedCommand = try? JSONDecoder().decode(GameSocketCommand.self, from: encodedCommand)
        guard let decodedCommand = decodedCommand else {
            throw GameSocketCommand.CommandError(errorCode: .malformedCommand)
        }
        
        return decodedCommand
    }
    
    private func handleCommand(_ socketCommand: GameSocketCommand) async throws -> GameStateResponse {
        let loadedStateInfo = try await self.loadGameStateInfo(socketCommand)
        let gameState = loadedStateInfo.plainGameState
        gameState.processInput(command: socketCommand.inputCommand)
        
        let updatedStateInfo = GameStateInfo(
            id: loadedStateInfo.id,
            filledTiles: gameState.filledTiles,
            playerPosition: gameState.playerPosition,
            isDead: gameState.isDead,
            itemScore: gameState.itemScore,
            stateKey: .init(),
            createdAt: loadedStateInfo.createdAt
        )
        
        if updatedStateInfo.isDead {
            // TODO: - Handle Death
            return updatedStateInfo.socketResponse
        } else {
            try await self.gameStateService.update(updatedStateInfo)
            return updatedStateInfo.socketResponse
        }
    }
    
    private func loadGameStateInfo(_ socketCommand: GameSocketCommand) async throws -> GameStateInfo {
        let loadedStateInfo = try await self.gameStateService.load(
            id: socketCommand.gameId,
            stateKey: socketCommand.nextActionKey
        )
        
        guard let loadedStateInfo = loadedStateInfo else {
            throw GameSocketCommand.CommandError(errorCode: .invalidGameId)
        }
        
        return loadedStateInfo
    }
}
