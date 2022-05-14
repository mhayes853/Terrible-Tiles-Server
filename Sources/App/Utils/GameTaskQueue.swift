//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

struct GameTaskQueue {
    private var tasks = [UUID: Task<Void, Error>]()
    
    mutating func addTask(id: UUID, _ fn: @escaping () async throws -> Void) {
        self.tasks[id] = Task { try await fn() }
    }
    
    mutating func removeTask(id: UUID) {
        self.tasks.removeValue(forKey: id)
    }
}
