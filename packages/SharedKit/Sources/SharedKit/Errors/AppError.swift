public enum AppError: Error, Codable, Sendable, Equatable {
    case notFound(message: String)
    case validationFailed(message: String)

    public var message: String {
        switch self {
        case .notFound(let m), .validationFailed(let m):
            return m
        }
    }
}





