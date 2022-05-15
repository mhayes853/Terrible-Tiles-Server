import Vapor
import Fluent
import FluentPostgresDriver
import Redis


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(
        .postgres(
            hostname: Env.dbHost,
            port: Env.dbPort,
            username: Env.dbUser,
            password: Env.dbPassword,
            database: Env.dbName
        ),
        as: .psql
    )
    
    app.migrations.add(CreateScores())
    
    app.redis.configuration = try .init(hostname: Env.redisHost)
    
    // register routes
    try routes(app)
}
