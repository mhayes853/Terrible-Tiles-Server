//
//  File.swift
//  
//
//  Created by Matthew Hayes on 6/14/22.
//

import Foundation

/// Play the game
actor GameLoop {
    private var gameState = GameState()
    private var eventTimings = EventTimings()
}

// MARK: - Setting inputs

extension GameLoop {
    /// Set the current player inputs while the game loop is running
    func setPlayerInputs(_ inputs: Set<InputCommand>) {
        self.gameState.playerInputs = inputs
    }
}

// MARK: - The actual loop

extension GameLoop {
    
    /// Run the main game loop at the desired fps
    func run(
        fps: Double = Constants.defaultFPS,
        _ onGameStateUpdate: (GameStateUpdate) -> Void
    ) async throws -> Int {
        self.spawnInitialItems(onGameStateUpdate)
        
        let secondsBetweenFrames = 1000.0 / (fps * 1000.0)
        
        while !self.gameState.isGameOver {
            try await delay(seconds: secondsBetweenFrames)
            let stateUpdate = self.updateGameState()
            onGameStateUpdate(stateUpdate)
        }
        
        return self.gameState.finalScoreNumber
    }
    
    private func updateGameState() -> GameStateUpdate {
        self.gameState.processCurrentInputs()
        
        let prevFilledTiles = self.gameState.filledTiles
        self.updateTilesState()
        
        let updatedTiles = self.gameState.filledTiles.filter { (pos, tile) -> Bool in
            guard let prevTile = prevFilledTiles[pos] else { return true }
            return prevTile != tile
        }
        
        return GameStateUpdate(
            playerPosition: self.gameState.playerPosition,
            updatedTiles: updatedTiles,
            bossHP: self.gameState.bossRemainingHP
        )
    }
    
    private func updateTilesState() {
        if self.eventTimings.lastDropTileDate.timeIntervalSinceNow <= -Constants.dropTileTimeInterval {
            self.gameState.dropRandomTile()
            self.eventTimings.lastDropTileDate = .now
        }
        
        if self.eventTimings.lastAttackPlayerState.timeIntervalSinceNow <= -Constants.attackPlayerTimeInterval {
            self.gameState.attackPlayer()
            self.eventTimings.lastAttackPlayerState = .now
        }
        
        if self.eventTimings.lastSpawnItemsDate.timeIntervalSinceNow <= -Constants.spawnItemsTimeInterval {
            self.gameState.spawnItems()
            self.eventTimings.lastSpawnItemsDate = .now
        }
    }
    
    private func spawnInitialItems(_ onFinish: (GameStateUpdate) -> Void) {
        self.gameState.spawnItems()
        let initialUpdate = GameStateUpdate(
            playerPosition: self.gameState.playerPosition,
            updatedTiles: self.gameState.filledTiles,
            bossHP: self.gameState.bossRemainingHP
        )
        
        onFinish(initialUpdate)
    }
    
}

// MARK: - Event timings

extension GameLoop {
    fileprivate struct EventTimings {
        var lastSpawnItemsDate = Date.now
        var lastDropTileDate = Date.now
        var lastAttackPlayerState = Date.now
    }
}

// MARK: - Constants

extension GameLoop {
    struct Constants {
        // 60 would only be needed on a client since they worry about visuals
        static let defaultFPS = 12.0
        
        static let dropTileTimeInterval: TimeInterval = 1.0
        static let attackPlayerTimeInterval: TimeInterval = 5.0
        static let spawnItemsTimeInterval: TimeInterval = 10.0
    }
}
