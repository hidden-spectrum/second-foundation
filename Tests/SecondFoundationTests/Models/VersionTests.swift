//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

@testable import SecondFoundation
import XCTest


final class VersionTests: XCTestCase {
    
    func testInitWithValidString() {
        let version = Version(string: "1.2.3")
        XCTAssertNotNil(version)
    }
    
    func testInitWithInvalidString() {
        let version = Version(string: "1.2")
        XCTAssertNil(version)
    }
    
    func testComparisonLessThan() {
        let version1 = Version(major: 1, minor: 9, patch: 3)
        let version2 = Version(major: 1, minor: 13, patch: 4)
        
        XCTAssertTrue(version1 < version2)
    }
    
    func testComparisonGreaterThan() {
        let version1 = Version(major: 1, minor: 3, patch: 13)
        let version2 = Version(major: 1, minor: 3, patch: 4)
        
        XCTAssertTrue(version1 > version2)
    }
    
    func testComparisonEqualTo() {
        let version1 = Version(major: 1, minor: 3, patch: 4)
        let version2 = Version(major: 1, minor: 3, patch: 4)
        
        XCTAssertTrue(version1 == version2)
    }
    
    func testStringValue() {
        let version = Version(major: 1, minor: 2, patch: 3)
        
        XCTAssertEqual(version.stringValue, "1.2.3")
    }
}
