//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Main Class

/// Class Containing main game logic
class GameState {
    var playerInputs = Defaults.playerInputs
    private(set) var filledTiles = Defaults.filledTiles
    private(set) var playerPosition = Defaults.playerPosition
    private(set) var isDead = Defaults.isDead
    private(set) var bossDamageDealt = Defaults.bossDamageDealt
    private(set) var totalItemsCollected = Defaults.itemsCollected
    private(set) var totalMoves = Defaults.totalMoves
    
    init(
        playerInputs: Set<InputCommand> = [],
        filledTiles: [Position: TileType] = Defaults.filledTiles,
        playerPosition: Position = Defaults.playerPosition,
        isDead: Bool = Defaults.isDead,
        itemScore: Int = Defaults.bossDamageDealt,
        totalItemsCollected: Int = Defaults.itemsCollected,
        totalMoves: Int = Defaults.totalMoves
    ) {
        self.playerInputs = playerInputs
        self.filledTiles = filledTiles
        self.playerPosition = playerPosition
        self.isDead = isDead
        self.bossDamageDealt = itemScore
        self.totalItemsCollected = totalItemsCollected
        self.totalMoves = totalMoves
    }
    
    /// A game is over if the player is dead or the boss is defeated
    var isGameOver: Bool {
        self.isDead || self.bossDamageDealt >= Constants.bossHP
    }
    
    /// Remaining Boss HP
    var bossRemainingHP: Int {
        Constants.bossHP - self.bossDamageDealt
    }
    
    /// Adds a random position to filledTiles with a "void" type
    func dropRandomTile() {
        self.fillRandomTile(with: .void, excludingTypes: [.void]) // Make sure existing items can be dropped
        self.updateGameStatus()
    }
    
    /// Pushes the player back 2-4 tiles decided randomly
    func attackPlayer() {
        let tileAmount = Constants.attackPlayerRange.randomElement()!
        self.playerPosition = .init(x: self.playerPosition.x, y: max(self.playerPosition.y - tileAmount, 0))
        self.updateGameStatus()
    }
    
    /// Spawns items randomly on the board
    ///
    /// The number of items spawned is 4.5% the amount of all unfilled tiles on the game board
    func spawnItems() {
        let itemsSpawned = Int(Double(Constants.totalTiles - self.filledTiles.count) * Constants.itemSpawnRate)
        var itemsLeftToSpawn = itemsSpawned
        
        // We shuffle the items list to make sure rarer items can still when less tiles remain
        Constants.itemTileTypes.shuffled()
            .map { item -> (Int, TileType) in
                let projectedSpawnAmount = Double(itemsSpawned) * item.spawnPercentage
                let amountToSpawn = Int(min(projectedSpawnAmount, Double(itemsLeftToSpawn)))
                itemsLeftToSpawn -= amountToSpawn
                return (amountToSpawn, item)
            }
            .forEach { (spawnAmount, item) in
                self.fillRandomTiles(with: item, amount: spawnAmount)
            }
        
        self.updateGameStatus()
    }
    
    fileprivate func updateGameStatus() {
        guard let playerTile = self.filledTiles[self.playerPosition] else { return }
        if playerTile != .void {
            self.bossDamageDealt = min(self.bossDamageDealt + playerTile.bossDamageValue, Constants.bossHP)
            self.totalItemsCollected += 1
            self.filledTiles.removeValue(forKey: self.playerPosition)
        } else {
            self.isDead = true
        }
    }
}

// MARK: - Player Input/Movement

extension GameState {
    /// Updates Game State based on the current player inputs
    func processCurrentInputs() {
        self.playerInputs.forEach(self.processInput)
    }
    
    /// Update Game State based on the input command
    func processInput(command: InputCommand) {
        if command == .leave {
            self.isDead = true
        } else {
            self.processMovement(command)
        }
    }
    
    private func processMovement(_ command: InputCommand) {
        self.movePlayer(command)
        self.updateGameStatus()
    }
    
    private func movePlayer(_ command: InputCommand) {
        let originalPosition = self.playerPosition
        
        switch command {
        case .moveDown:
            self.playerPosition = .init(x: self.playerPosition.x, y: max(self.playerPosition.y - 1, 0))
        case .moveUp:
            self.playerPosition = .init(x: self.playerPosition.x, y: min(self.playerPosition.y + 1, Constants.maxRows - 1))
        case .moveLeft:
            self.playerPosition = .init(x: max(self.playerPosition.x - 1, 0), y: self.playerPosition.y)
        case .moveRight:
            self.playerPosition = .init(x: min(self.playerPosition.x + 1, Constants.maxCols - 1), y: self.playerPosition.y)
        default:
            return
        }
        
        // Walking against a wall does not increase movement count
        if originalPosition != self.playerPosition {
            self.totalMoves += 1
        }
    }
}

// MARK: - Finding/Filling Open Tiles to place items or drop tiles

extension GameState {
    fileprivate func fillRandomTiles(
        with type: TileType,
        amount: Int,
        excludingTypes excluded: Set<TileType> = .init(TileType.allCases)
    ) {
        for _ in 0..<amount {
            self.fillRandomTile(with: type, excludingTypes: excluded)
        }
    }
    
    fileprivate func fillRandomTile(with type: TileType, excludingTypes excluded: Set<TileType> = .init(TileType.allCases)) {
        guard let pos = self.findRandomOpenTilePosition(excludingTypes: excluded) else { return }
        self.filledTiles[pos] = type
    }
    
    private func findRandomOpenTilePosition(excludingTypes excluded: Set<TileType>) -> Position? {
        guard self.filledTiles.count != Constants.totalTiles else { return nil }
        
        let basePos = Position.random(in: 0..<Constants.maxCols, and: 0..<Constants.maxRows)
        
        for i in basePos.x..<Constants.maxCols {
            let searchPos = Position(x: i, y: basePos.y)
            if let pos = self.findOpenTilePositionInCol(basePosition: searchPos, excludingTypes: excluded) {
                return pos
            }
        }
        
        for i in stride(from: basePos.x, to: -1, by: -1) {
            let searchPos = Position(x: i, y: basePos.y)
            if let pos = self.findOpenTilePositionInCol(basePosition: searchPos, excludingTypes: excluded) {
                return pos
            }
        }
        
        // This would mean that every tile is filled with something (which should be handled by the guard?)
        return nil
    }
    
    private func findOpenTilePositionInCol(
        basePosition base: Position,
        excludingTypes excluded: Set<TileType>
    ) -> Position? {
        for i in base.y..<Constants.maxRows {
            let pos = Position(x: base.x, y: i)
            if self.isOpenTilePosition(position: pos, excludingTypes: excluded) {
                return pos
            }
        }
        
        for i in stride(from: base.y, to: -1, by: -1) {
            let pos = Position(x: base.x, y: i)
            if self.isOpenTilePosition(position: pos, excludingTypes: excluded) {
                return pos
            }
        }
        
        return nil
    }
    
    private func isOpenTilePosition(position: Position, excludingTypes excluded: Set<TileType>) -> Bool {
        let isInRowRange = (0..<Constants.maxRows).contains(position.y)
        let isInColRange = (0..<Constants.maxCols).contains(position.x)
        
        guard isInRowRange && isInColRange else { return false }
        guard let item = self.filledTiles[position] else { return true }
        return !excluded.contains(item)
    }
}

// MARK: - Constants

extension GameState {
    enum Constants {
        // An Odd number gives the board a clear "middle" position
        static let maxRows = 15
        static let maxCols = 25
        static let totalTiles = maxCols * maxRows
        
        static let attackPlayerRange = 2..<5
        
        static let itemSpawnRate = 0.045
        static let itemTileTypes = [TileType.blueItem, TileType.redItem, TileType.purpleItem, TileType.pinkItem]
        
        static let bossHP = 500
    }
}

// MARK: - Defaults

extension GameState {
    enum Defaults {
        static let playerInputs = Set<InputCommand>()
        static let filledTiles = [Position: TileType]()
        static let playerPosition = Position(x: 12, y: 7)
        static let isDead = false
        static let bossDamageDealt = 0
        static let itemsCollected = 0
        static let totalMoves = 0
    }
}

// MARK: - Helpers

private extension Position {
    static func random(in xrange: Range<Int>, and yrange: Range<Int>) -> Self {
        return .init(x: xrange.randomElement() ?? 0, y: yrange.randomElement() ?? 0)
    }
}
