import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 8080

    if let urlString = Environment.get("DATABASE_URL"), let url = URL(string: urlString) {
        app.databases.use(try .postgres(url: url), as: .psql)
    }

    try routes(app)
}





