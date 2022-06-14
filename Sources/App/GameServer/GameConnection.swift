//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/13/22.
//

import Foundation

/// Behavior for game event interaction over external interfaces
protocol GameConnection {
    func observePlayerInput(_ inputHandler: @escaping (Set<InputCommand>) async throws -> Void)
    func sendGameStateResponse(_ resp: GameStateResponse) async throws
}
