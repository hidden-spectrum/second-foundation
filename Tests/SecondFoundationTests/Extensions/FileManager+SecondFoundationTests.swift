//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import SecondFoundation
import XCTest


final class FileManager_SecondFoundationTests: XCTestCase {
    
    func testEnumeratorCreation() async throws {
        let fileManager = FileManager.default
        let url = Bundle(for: type(of: self)).bundleURL
        
        let enumerator = try fileManager.enumerator(for: url)
        
        XCTAssertNotNil(enumerator)
    }
}

final class AsyncDirectoryEnumeratorTests: XCTestCase {
    
    func testAsyncIteration() async throws {
        let fileManager = FileManager.default
        let url = Bundle(for: type(of: self)).bundleURL
        let enumerator = try fileManager.enumerator(for: url)
        
        var count = 0
        for await _ in enumerator {
            count += 1
        }
        
        XCTAssert(count > 0, "Should enumerate at least one URL")
    }
}

final class AsyncDirectoryEnumeratorIteratorTests: XCTestCase {
    
    func testIteratorNext() async throws {
        let fileManager = FileManager.default
        let url = Bundle(for: type(of: self)).bundleURL
        let enumerator = try fileManager.enumerator(for: url)
        let iterator = enumerator.makeAsyncIterator()
        let fileUrl = await iterator.next()
        XCTAssertNotNil(fileUrl)
    }
}
