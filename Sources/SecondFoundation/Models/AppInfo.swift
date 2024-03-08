//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation
import os.log


public struct AppInfo {
    
    // MARK: Public
    
    public let version: String
    public let buildNumber: Int
    
    // MARK: Private
    
    private let logger = Logger(subsystem: "io.hiddenspectrum.secondfoundation", category: "AppInfo")
    
    // MARK: Lifecycle
    
    public init?(bundle: Bundle = .main) {
        guard let buildNumberString = bundle.infoDictionary?["CFBundleVersion"] as? String,
              let buildNumber = Int(buildNumberString),
              let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        else {
            logger.error("Unable to init AppInfo, bundle information may not be present")
            return nil
        }
        self.version = version
        self.buildNumber = buildNumber
    }
}
