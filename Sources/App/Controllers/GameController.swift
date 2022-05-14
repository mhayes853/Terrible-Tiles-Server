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
    private var taskQueue = GameTaskQueue()
    
    init(_ scoresService: ScoresService) {
        self.scoresService = scoresService
    }
    
    func boot(routes: RoutesBuilder) throws {
        let game = routes.grouped("game")
        game.webSocket("connect", onUpgrade: self.handleGameConnection)
    }
    
    private func handleGameConnection(req: Request, ws: WebSocket) async {
        // TODO: Process initialization
        ws.onText(self.handleGameCommand)
    }
    
    private func handleGameCommand(ws: WebSocket, text: String) async {
        guard let encodedTextData = text.data(using: .utf8) else {
            try? await ws.sendExitError(gameErrorCode: .malformedCommand)
            return
        }
        
        let actionRequest = try? JSONDecoder().decode(GameSocketCommand.self, from: encodedTextData)
        guard let actionRequest = actionRequest else {
            try? await ws.sendExitError(gameErrorCode: .malformedCommand)
            return
        }
        
        // TODO: - Process the Action Request and Update Game State
        try? await ws.sendJSON(actionRequest)
    }
}
