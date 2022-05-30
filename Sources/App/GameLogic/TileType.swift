//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

/// All the forms a tile can be, minus the base form
enum TileType: String, Codable, CaseIterable {
    case redItem = "RED_ITEM"
    case blueItem = "BLUE_ITEM"
    case purpleItem = "PURPLE_ITEM"
    case pinkItem = "PINK_ITEM"
    case void = "VOID"
}

extension TileType {
    var scoreValue: Int {
        switch self {
        case .redItem:
            return 1
        case .blueItem:
            return 3
        case .purpleItem:
            return 5
        case .pinkItem:
            return 10
        default:
            return -1
        }
    }
    
    var spawnPercentage: Double {
        switch self {
        case .redItem:
            return 0.5
        case .blueItem:
            return 0.2
        case .purpleItem:
            return 0.2
        case .pinkItem:
            return 0.1
        default:
            return 0.0
        }
    }
}
