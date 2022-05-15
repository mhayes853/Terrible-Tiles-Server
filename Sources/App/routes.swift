import Vapor

func routes(_ app: Application) throws {
    let scoresService = ScoresService(app.db)
    let gameStateService = GameStateService(app.redis)
    try app.register(collection: GameController(scoresService, gameStateService))
}
