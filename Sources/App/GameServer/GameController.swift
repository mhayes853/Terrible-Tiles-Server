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
    
    init(_ scoresService: ScoresService) {
        self.scoresService = scoresService
    }
    
    func boot(routes: RoutesBuilder) throws {
        let game = routes.grouped("game")
        game.webSocket("connect", onUpgrade: self.handleGameConnection)
    }
    
    private func handleGameConnection(req: Request, ws: WebSocket) async {
        do {
            let finalScore = try await GameConnection(ws: ws).playGame()
            try await self.scoresService.insertNew(score: finalScore)
            
            let topScores = try await self.scoresService.topScores()
            let response = GameScoreResponse(gameId: finalScore.id, playerScore: finalScore, topScores: topScores)
            try await ws.sendEncodable(response)
            try await ws.close()
        } catch {
            try? await ws.closeWithErrorResponse(
                gameErrorCode: .internalError,
                socketErrorCode: .unexpectedServerError
            )
        }
    }
}
