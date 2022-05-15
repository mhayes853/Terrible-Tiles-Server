//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/14/22.
//

import Foundation
import RediStack

extension UUID {
    var redisKey: RedisKey {
        .init(self.uuidString)
    }
}
