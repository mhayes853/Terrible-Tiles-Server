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
            let socketCommand = try GameSocketCommand(rawText: text)
            let updatedInfo = try await self.gameStateService.runCommand(
                gameId: socketCommand.gameId,
                input: socketCommand.inputCommand,
                stateKey: socketCommand.nextActionKey
            )
            
            if updatedInfo.isDead {
                // Game Over, send score back to the client and clean up game state
                try await self.closeGame(ws: ws, gameStateInfo: updatedInfo)
            } else {
                try await ws.sendEncodable(updatedInfo.socketResponse)
            }
        } catch let error as GameStateService.StateError {
            try? await ws.sendGameError(error == .badStateKey ? .invalidStateKey : .invalidGameId)
        } catch let error as GameSocketCommand.CommandError {
            try? await ws.sendGameError(error.errorCode)
        } catch {
            try? await ws.closeWithErrorResponse(
                gameErrorCode: .internalError,
                socketErrorCode: .unexpectedServerError
            )
        }
    }
    
    private func closeGame(ws: WebSocket, gameStateInfo: GameStateInfo) async throws {
        // TODO: - Delete Long-Running Game Task to Drop Tiles
        try await self.gameStateService.remove(id: gameStateInfo.id)
        let response = try await self.handleFinalScore(gameStateInfo: gameStateInfo)
        try await ws.sendEncodable(response)
        try await ws.close()
        try await self.scoresService.insertNew(score: response.playerScore)
    }
    
    private func handleFinalScore(gameStateInfo: GameStateInfo) async throws -> GameScoreResponse {
        let finalScore = gameStateInfo.calculatefinalScore()
        try await self.scoresService.insertNew(score: finalScore)
        let topScores = try await self.scoresService.topScores()
        return .init(gameId: gameStateInfo.id, playerScore: finalScore, topScores: topScores)
    }
}
