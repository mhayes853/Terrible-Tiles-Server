//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation

enum MovementDirection {
    case up, down, left, right
    
    /// Where to change the position of the player on the game board
    var positionChange: (x: Int, y: Int) {
        switch self {
        case .up:
            return (x: 0, y: -1)
        case .down:
            return (x: 0, y: 1)
        case .left:
            return (x: -1, y: 0)
        case .right:
            return (x: 1, y: 0)
        }
    }
}
