import Vapor
import Fluent
import FluentSQLiteDriver


// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.sqlite(.file(AppConstants.sqlitePath)), as: .sqlite)
    app.migrations.add(CreateScores())
    
    try app.autoMigrate().wait()
    
    configureCORS(app)
    
    // register routes
    try routes(app)
}

private func configureCORS(_ app: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    
    app.middleware.use(cors, at: .beginning)
}
