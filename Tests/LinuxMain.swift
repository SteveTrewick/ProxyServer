import XCTest

import ProxyServerTests

var tests = [XCTestCaseEntry]()
tests += ProxyServerTests.allTests()
XCTMain(tests)
