//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import SecondFoundation
import XCTest
import SwiftUI


final class ByteCountForamtter_SecondFoundationTests: XCTestCase {
    func testStringInterpolation() {
        let fileSize: Int64 = 1024
        let expected = "File size is: 1 KB"
        let string = "File size is: \(fileSize: fileSize)"
        XCTAssertEqual(string, expected)
    }
}
