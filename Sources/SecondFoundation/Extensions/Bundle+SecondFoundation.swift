//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation


private class CurrentBundleFinder {}

extension Bundle {
    static let secondFoundation = Bundle.forPackage(bundleName: "SecondFoundation_SecondFoundation", referenceClass: CurrentBundleFinder.self)
}


public extension Bundle {
    static func forPackage<T: AnyObject>(bundleName: String, referenceClass: T.Type) -> Bundle {
        let candidates = [
            // App
            Bundle.main.resourceURL,
            
            // Packge linked into framework
            Bundle(for: referenceClass).resourceURL,
            
            // UITests
            Bundle(for: referenceClass).resourceURL?.deletingLastPathComponent(),
            
            // Command line tools
            Bundle.main.bundleURL,

            // Nested package targets
            Bundle(for: referenceClass).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            Bundle(for: referenceClass).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]
        
        for candidate in candidates {
            let bundlePathiOS = candidate?.appendingPathComponent(bundleName + ".bundle")
            let bundlePathMacOS = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePathiOS.flatMap(Bundle.init(url:)) {
                return bundle
            } else if let bundle = bundlePathMacOS.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        preconditionFailure("Couldn't find bundle with name: " + bundleName)
    }
}
