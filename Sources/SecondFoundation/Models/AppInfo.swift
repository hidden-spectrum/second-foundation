//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import os.log


public struct AppInfo {
    
    // MARK: Public
    
    public let version: String
    public let buildNumber: Int
    
    // MARK: Private
    
    private let logger = Logger(subsystem: "ios.hiddenspectrum.secondfoundation", category: "AppInfo")
    
    // MARK: Lifecycle
    
    init?() {
        guard let buildNumberString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
              let buildNumber = Int(buildNumberString),
              let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else {
            logger.error("Unable to init AppInfo, bundle information may not be present")
            return nil
        }
        self.version = version
        self.buildNumber = buildNumber
    }
}
