//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import SecondFoundation
import XCTest


final class DurationFormatterTests: XCTestCase {

    func testDurationFormatting() {
        let formatter = DurationFormatter()
        
        XCTAssertEqual(formatter.string(for: 0), "")
        XCTAssertEqual(formatter.string(for: 0.123), "123ms")
        XCTAssertEqual(formatter.string(for: 1), "1s")
        XCTAssertEqual(formatter.string(for: 60), "1m")
        XCTAssertEqual(formatter.string(for: 3600), "1h")
        XCTAssertEqual(formatter.string(for: 3661.123), "1h 1m 1s 123ms")
        XCTAssertEqual(formatter.string(for: 83.512), "1m 23s 512ms")
    }
}


final class StringInterpolationExtensionTests: XCTestCase {

    func testStringInterpolation() {
        let interpolatedString = "\(duration: 3661.123)"
        
        XCTAssertEqual(interpolatedString, "1h 1m 1s 123ms")
    }
}
