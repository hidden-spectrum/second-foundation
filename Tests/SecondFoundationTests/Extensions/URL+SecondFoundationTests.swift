//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

@testable import SecondFoundation
import UniformTypeIdentifiers
import XCTest


final class URL_SecondFoundationTests: XCTestCase {
    
    func testAppendingFileName() {
        let originalURL = URL(string: "https://example.com/original/")!
        let anotherURL = URL(string: "https://example.com/sample.txt")!
        let utType = UTType("public.jpeg")!
        
        let resultURL = originalURL.appendingFileName(from: anotherURL, conformingTo: utType)
        
        XCTAssertEqual(resultURL, URL(string: "https://example.com/original/sample.jpeg")!)
    }
    
    func testReplacingFileExtension() {
        let originalURL = URL(string: "https://example.com/original.mp4")!
        let utType = UTType("public.jpeg")!
        
        let resultURL = originalURL.replacingFileExtension(with: utType)
        
        XCTAssertEqual(resultURL, URL(string: "https://example.com/original.jpeg")!)
    }
}
