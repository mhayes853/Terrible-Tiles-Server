import Vapor
import Fluent
import FluentSQLiteDriver


// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.sqlite(.file(Env.sqlitePath)), as: .sqlite)
    app.migrations.add(CreateScores())
    
    // register routes
    try routes(app)
}
