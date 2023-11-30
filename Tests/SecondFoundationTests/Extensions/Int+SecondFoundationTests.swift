//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import SecondFoundation
import XCTest


final class Int_SecondFoundationTests: XCTestCase {
    
    func testWrapped() {
        XCTAssertEqual(5.wrapped(limit: 10, base: 0), 5)
        XCTAssertEqual(10.wrapped(limit: 10, base: 0), 10)
        XCTAssertEqual(15.wrapped(limit: 10, base: 1), 5)
        XCTAssertEqual((-5).wrapped(limit: 10, base: 1), 5)
        XCTAssertEqual(5.wrapped(limit: 10, base: 5), 5)
        XCTAssertEqual(14.wrapped(limit: 12, base: 1), 2)
        XCTAssertEqual((-3).wrapped(limit: 11, base: 0), 9)
    }
}
