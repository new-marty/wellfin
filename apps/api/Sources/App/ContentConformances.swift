import Vapor
import SharedKit

// Vapor-specific conformance kept in API target to avoid coupling SharedKit to Vapor.
extension UserDTO: Content {}


