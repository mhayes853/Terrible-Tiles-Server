//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation

// MARK: - Game Tile Struct

struct GameTile: Codable {
    var pos: Position
    let content: Content
}

// MARK: - Content (Aka, the current form of the tile)

extension GameTile {
    enum Content: Codable {
        case redItem
        case greenItem
        case blueItem
        case pinkItem
        case purpleItem
        
        /// This denotes a pitfall, if the player lands on this tile, they die
        case void
        
        var score: Int {
            switch self {
            case .redItem:
                return 5
            case .greenItem:
                return 3
            case .blueItem:
                return 1
            case .pinkItem:
                return 10
            case .purpleItem:
                return 20
            default:
                return -1
            }
        }
    }
}


