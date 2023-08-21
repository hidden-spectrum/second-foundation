//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import os.log
import StoreKit
import SwiftUI


public struct StoreReviewPromptManagerEvent {
    
    // MARK: Public
    
    public typealias Event = Self
    
    public let points: Int
    public let promptDelayInSeconds: UInt64
    
    // MARK: Lifecycle
    
    public init(points: Int, promptDelayInSeconds: UInt64 = 1) {
        self.points = points
        self.promptDelayInSeconds = promptDelayInSeconds
    }
}


public final class StoreReviewPromptManager {
    
    // MARK: Public private(set)
    
    @AppStorage(.reviewPromptKarma) public private(set) var karma = 0
    
    // MARK: Internal
    
    @AppStorage(.lastVersionPromptedForStoreReview) var lastPromptVersion: String?
    
    let appInfo = AppInfo()
    let promptThreshold: UInt
    
    // MARK: Private
    
    private let logger = Logger(subsystem: "io.hiddenspectrum.secondfoundation", category: "StoreReviewPromptManager")
    
    // MARK: Lifecycle
    
    public init(promptThreshold: UInt) {
        self.promptThreshold = promptThreshold
    }
    
    // MARK: Event logging
    
    public func logPoints(for event: StoreReviewPromptManagerEvent) {
        karma += event.points
        guard karma >= promptThreshold else {
            return
        }
        if let appVersion = appInfo?.version {
            if lastPromptVersion != appVersion {
                promptForStoreReview(delay: event.promptDelayInSeconds)
            }
        } else {
            logger.warning("Could not determine app version, user may be prompted to review again for this version")
            promptForStoreReview(delay: event.promptDelayInSeconds)
        }
    }
    
    // MARK: Prompt
    
    private func promptForStoreReview(delay: UInt64) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay * 1_000_000_000)
            SKStoreReviewController.requestReview()
            lastPromptVersion = appInfo?.version
            karma = 0
        }
    }
}


private extension String {
    static let reviewPromptKarma = "StoreReviewPromptKarma"
    static let lastVersionPromptedForStoreReview = "LastVersionPromptedForStoreReview"
}
