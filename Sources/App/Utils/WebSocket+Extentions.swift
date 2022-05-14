//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor
import NIOWebSocket

// MARK: - Sending Encodabe Easily

extension WebSocket {
    func sendJSON<T: Encodable>(_ data: T) async throws {
        let encoded = try JSONEncoder().encode(data)
        try await self.send([UInt8](encoded))
    }
}

// MARK: - Sending an error and closing

extension WebSocket {
    func sendExitError(
        gameErrorCode: GameSocketErrorCode,
        socketErrorCode: WebSocketErrorCode = .policyViolation
    ) async throws {
        let errorResponse = gameErrorCode.defaultErrorResponse
        try await self.sendJSON(errorResponse)
        try await self.close(code: socketErrorCode)
    }
}
