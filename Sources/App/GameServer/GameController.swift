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
    private let logger: Logger
    
    init(_ scoresService: ScoresService, _ logger: Logger) {
        self.scoresService = scoresService
        self.logger = logger
    }
    
    func boot(routes: RoutesBuilder) throws {
        let game = routes.grouped("game")
        game.webSocket("connect", onUpgrade: self.handleGameConnection)
    }
    
    private func handleGameConnection(req: Request, ws: WebSocket) async {
        do {
            try await self.runGameConnection(ws: ws)
            try await ws.close()
        } catch {
            self.logger.error("\(error)")
            try? await ws.closeWithErrorResponse(
                gameErrorCode: .internalError,
                socketErrorCode: .unexpectedServerError
            )
        }
    }
    
    private func runGameConnection(ws: WebSocket) async throws {
        let gameActor = await GameActor(ws: ws)
        let finalScore = try await GameConnection(gameActor: gameActor).playGame()
        try await self.sendTopScoresResponse(playerScore: finalScore, ws: ws)
    }
    
    private func sendTopScoresResponse(playerScore: Score, ws: WebSocket) async throws {
        let response = try await self.makeTopScoresResponse(playerScore: playerScore)
        try await ws.sendEncodable(response)
    }
    
    private func makeTopScoresResponse(playerScore: Score) async throws -> GameScoreResponse {
        try await self.scoresService.insertNew(score: playerScore)
        let topScores = try await self.scoresService.topScores()
        return .init(gameId: playerScore.id, playerScore: playerScore, topScores: topScores)
    }
}
