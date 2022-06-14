//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation
import Vapor
import NIOWebSocket

// MARK: - Sending Encodable Easily

extension WebSocket {
    func sendEncodable<T: Encodable>(_ data: T) async throws {
        let encoded = try JSONEncoder.defaultEncoder.encode(data)
        try await self.send([UInt8](encoded))
    }
}

// MARK: - Sending Error Easily

extension WebSocket {
    func sendGameError(_ errorCode: GameConnectionErrorCode) async throws {
        try await self.sendEncodable(errorCode.defaultErrorResponse)
    }
}

// MARK: - Sending an error and closing

extension WebSocket {
    func closeWithErrorResponse(
        gameErrorCode: GameConnectionErrorCode,
        socketErrorCode: WebSocketErrorCode = .policyViolation
    ) async throws {
        try await self.sendGameError(gameErrorCode)
        try await self.close(code: socketErrorCode)
    }
}
