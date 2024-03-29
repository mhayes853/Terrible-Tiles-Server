//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Main Model

/// Socket specific game error codes
enum GameConnectionErrorCode: String, Encodable {
    case invalidGameId = "INVALID_GAME_ID"
    case invalidStateKey = "INVALID_STATE_KEY"
    case malformedCommand = "MALFORMED_COMMAND"
    case internalError = "INTERNAL_ERROR"
}

// MARK: - Convienient Way to Construct Error Responses

extension GameConnectionErrorCode {
    var defaultErrorResponse: GameErrorResponse {
        .init(errorCode: self, message: self.defaultErrorMessage)
    }
    
    var defaultErrorMessage: String {
        switch self {
        case .invalidGameId:
            return "The Game id is either invalid, already finished, or does not exist."
        case .invalidStateKey:
            return "The action key is invalid, please make sure you send the proper action key on every command."
        case .malformedCommand:
            return "The command contained data that was not sent in the correct format."
        case .internalError:
            return "An internal error on the server occurred."
        }
    }
}
