//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/16/22.
//

import Foundation

/// Determines the seed of which the game state generates items and drops tiles
/// (We give a seed option so we can have deterministic results for testing)
enum RNGFactor {
    case seed(Int)
    case time
}
