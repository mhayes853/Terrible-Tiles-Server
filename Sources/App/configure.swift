import Vapor
import Fluent
import FluentSQLiteDriver


// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.sqlite(.file(AppConstants.sqlitePath)), as: .sqlite)
    app.migrations.add(CreateScores())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
