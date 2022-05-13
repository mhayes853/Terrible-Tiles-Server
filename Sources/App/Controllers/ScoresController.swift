//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/12/22.
//

import Foundation
import Vapor

class ScoresController: RouteCollection {
    private let scoresService: ScoresService
    
    init(_ service: ScoresService) {
        self.scoresService = service
    }
    
    func boot(routes: RoutesBuilder) throws {
        let scores = routes.grouped("scores")
        scores.get("top", use: self.topScores)
    }
    
    /// REST endpoint to return the top scores in the database
    func topScores(req: Request) async throws -> [Score] {
        guard let amount = req.query[Int.self, at: "amount"] else {
            throw Abort(.badRequest)
        }
        
        return try await self.scoresService.topScores(amount: amount)
    }
}
