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
    
    // MARK: Public
    
    public typealias KarmaClosure = (Int) -> Void
    public typealias LastPromptVersionClosure = (String) -> Void
    
    // MARK: Public private(set)
    
    @AppStorage(.reviewPromptKarma) public private(set) var karma = 0
    
    // MARK: Internal
    
    @AppStorage(.lastVersionPromptedForStoreReview) var lastPromptVersion: String?
    
    let appInfo = AppInfo()
    let promptThreshold: UInt
    
    // MARK: Private
    
    private let logger = Logger(subsystem: "io.hiddenspectrum.secondfoundation", category: "StoreReviewPromptManager")
    
    private var karmaChangeAction: KarmaClosure?
    private var promptedForReviewAction: LastPromptVersionClosure?
    
    // MARK: Lifecycle
    
    public init(promptThreshold: UInt) {
        self.promptThreshold = promptThreshold
    }
    
    // MARK: Setup
    
    public func onKarmaChange(perform action: KarmaClosure?) -> Self {
        karmaChangeAction = action
        return self
    }
    public func onPromptedForReview(perform action: LastPromptVersionClosure?) -> Self {
        promptedForReviewAction = action
        return self
    }
    
    // MARK: Event logging
    
    public func logPoints(for event: StoreReviewPromptManagerEvent) {
        defer {
            karmaChangeAction?(karma)
        }
        
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
            
            karma = 0
            
            if let appVersion = appInfo?.version {
                lastPromptVersion = appVersion
                promptedForReviewAction?(appVersion)
            }
        }
    }
}


private extension String {
    static let reviewPromptKarma = "StoreReviewPromptKarma"
    static let lastVersionPromptedForStoreReview = "LastVersionPromptedForStoreReview"
}
