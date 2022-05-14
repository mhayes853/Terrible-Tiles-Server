import Vapor

func routes(_ app: Application) throws {
    let scoresService = ScoresService(app.db)
    try app.register(collection: GameController(scoresService))
}
