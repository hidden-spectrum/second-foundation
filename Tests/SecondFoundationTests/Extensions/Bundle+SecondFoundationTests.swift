//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import SecondFoundation
import Foundation
import XCTest


private class CurrentBundleFinder {}


final class Bundle_SecondFoundationTests: XCTestCase {

    func testBundleForSharedPackage() {
        let bundle = Bundle.forPackage(bundleName: "SecondFoundation_SecondFoundationTests", referenceClass: CurrentBundleFinder.self)
        XCTAssertNotNil(bundle)
    }
    
    func testBundleForSharedPackage_shouldReturnModule_whenBundleIsNotFound() {
        let bundle = Bundle.forPackage(bundleName: "NonExistentBundle", referenceClass: CurrentBundleFinder.self)
        XCTAssertEqual(bundle, .secondFoundation)
    }
}
