//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/17/22.
//

import Foundation

/// A protocol for any socket response that contains game information
protocol GameSocketResponse: Encodable {
    var gameId: UUID { get }
}
