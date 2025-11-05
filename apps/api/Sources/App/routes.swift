import Vapor
import SharedKit

func routes(_ app: Application) throws {
    app.get("health") { req async -> String in
        "ok"
    }

    app.get("version") { req async -> [String: String] in
        ["service": "FinanceAPI", "status": "running"]
    }

    app.get("user", ":id") { req async throws -> UserDTO in
        guard let id = req.parameters.get("id") else { throw Abort(.badRequest) }
        return UserDTO(id: id, displayName: "Sample User")
    }
}





