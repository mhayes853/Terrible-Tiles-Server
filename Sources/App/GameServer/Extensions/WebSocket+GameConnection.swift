//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/13/22.
//

import Foundation
import WebSocketKit

extension WebSocket: GameConnection {
    func observePlayerInput(_ inputHandler: @escaping (Set<InputCommand>) async throws -> Void) {
        self.onText { ws, text in
            do {
                let commands = try Set<InputCommand>(rawText: text)
                try await inputHandler(commands)
            } catch let error as GameConnectionError {
                try? await self.sendGameError(error.errorCode)
            } catch {
                try? await self.sendGameError(.internalError)
            }
        }
    }
    
    func sendGameStateResponse(_ resp: GameStateResponse) async throws {
        try await self.sendEncodable(resp)
    }
}
