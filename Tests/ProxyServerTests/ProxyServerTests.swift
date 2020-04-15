import XCTest
@testable import ProxyServer

final class ProxyServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ProxyServer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
