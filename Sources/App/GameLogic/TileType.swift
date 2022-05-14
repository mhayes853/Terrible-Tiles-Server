//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

/// All the forms a tile can be, minus the base form
enum TileType: String, Codable {
    case redItem = "RED_ITEM"
    case blueItem = "BLUE_ITEM"
    case purpleItem = "PURPLE_ITEM"
    case pinkItem = "PINK_ITEM"
    case void = "VOID"
}
