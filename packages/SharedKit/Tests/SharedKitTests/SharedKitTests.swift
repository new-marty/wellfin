import XCTest
@testable import SharedKit

final class SharedKitTests: XCTestCase {
    func testValidation() {
        XCTAssertTrue(Validation.isNonEmpty("hello"))
        XCTAssertFalse(Validation.isNonEmpty("   "))
    }
}





