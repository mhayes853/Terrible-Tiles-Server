//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Main Enum

/// Input Commands from the player
enum InputCommand: String, Codable {
    case moveUp = "MOVE_UP"
    case moveDown = "MOVE_DOWN"
    case moveLeft = "MOVE_LEFT"
    case moveRight = "MOVE_RIGHT"
    case leave = "LEAVE"
}

// MARK: - Helper Properties

extension InputCommand {
    var isMovement: Bool {
        self != .leave
    }
}
