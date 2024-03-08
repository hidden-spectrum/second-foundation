//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

@testable import SecondFoundation
import XCTest


final class Array_SecondFoundationTests: XCTestCase {
    
    func testRotatedByPositive() {
        let array = [1, 2, 3, 4, 5]
        let result = array.rotated(by: 2)
        XCTAssertEqual(result, [3, 4, 5, 1, 2])
    }

    func testRotatedByNegative() {
        let array = [1, 2, 3, 4, 5]
        let result = array.rotated(by: -1)
        XCTAssertEqual(result, [5, 1, 2, 3, 4])
    }

    func testRotatedByZero() {
        let array = [1, 2, 3, 4, 5]
        let result = array.rotated(by: 0)
        XCTAssertEqual(result, array)
    }

    func testRotatedByEmptyArray() {
        let array: [Int] = []
        let result = array.rotated(by: 1)
        XCTAssertEqual(result, [])
    }
}
