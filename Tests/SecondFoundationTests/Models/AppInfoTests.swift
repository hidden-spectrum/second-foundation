//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

@testable import SecondFoundation
import XCTest


final class AppInfoTests: XCTestCase {
    
    func testInitWithValidInfoDictionary() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = ["CFBundleVersion": "1", "CFBundleShortVersionString": "1.0"]
        
        let appInfo = AppInfo(bundle: mockBundle)
        
        XCTAssertNotNil(appInfo)
        XCTAssertEqual(appInfo?.version, "1.0")
        XCTAssertEqual(appInfo?.buildNumber, 1)
    }
    
    func testInitWithMissingVersion() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = ["CFBundleVersion": "1"]
        
        let appInfo = AppInfo(bundle: mockBundle)
        
        XCTAssertNil(appInfo)
    }
    
    func testInitWithMissingBuildNumber() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = ["CFBundleShortVersionString": "1.0"]
        
        let appInfo = AppInfo(bundle: mockBundle)
        
        XCTAssertNil(appInfo)
    }
    
    func testInitWithInvalidBuildNumber() {
        let mockBundle = MockBundle()
        mockBundle.mockInfoDictionary = ["CFBundleVersion": "invalid", "CFBundleShortVersionString": "1.0"]
        
        let appInfo = AppInfo(bundle: mockBundle)
        
        XCTAssertNil(appInfo)
    }
}


private final class MockBundle: Bundle {
    var mockInfoDictionary: [String: Any] = [:]
    
    override var infoDictionary: [String : Any]? {
        return mockInfoDictionary
    }
}
