//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation
import os.log
import StoreKit
import SwiftUI


#if os(iOS) || os(macOS)

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


@available(macOS 12, iOS 15, *)
public final class StoreReviewPromptManager {
    
    // MARK: Public
    
    public typealias KarmaClosure = (Int) -> Void
    public typealias LastPromptVersionClosure = (String?) -> Void
    
    // MARK: Public private(set)
    
    @AppStorage(.reviewPromptKarma) public private(set) var karma = 0
    
    // MARK: Internal
    
    @AppStorage(.lastVersionPromptedForStoreReview) var lastPromptVersion: String?
    
    let promptThreshold: UInt
    
    // MARK: Private
    
    private let appInfo = AppInfo()
    private let logger = Logger(subsystem: "io.hiddenspectrum.secondfoundation", category: "StoreReviewPromptManager")
    
    private var karmaChangeAction: KarmaClosure?
    private var willPromptForReviewAction: LastPromptVersionClosure?
    
    // MARK: Lifecycle
    
    public init(promptThreshold: UInt) {
        self.promptThreshold = promptThreshold
    }
    
    // MARK: Setup
    
    @discardableResult
    public func onKarmaChange(perform action: KarmaClosure?) -> Self {
        karmaChangeAction = action
        return self
    }
    
    @discardableResult
    public func onWillPromptForReview(perform action: LastPromptVersionClosure?) -> Self {
        willPromptForReviewAction = action
        return self
    }
    
    // MARK: Event logging
    
    public func logPoints(for event: StoreReviewPromptManagerEvent) {
        karma += event.points
        karmaChangeAction?(karma)
        
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
        karma = 0
        
        let appVersion = appInfo?.version
        lastPromptVersion = appVersion
        willPromptForReviewAction?(appVersion)
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay * 1_000_000_000)
            SKStoreReviewController.requestReview()
        }
    }
}


private extension String {
    static let reviewPromptKarma = "StoreReviewPromptKarma"
    static let lastVersionPromptedForStoreReview = "LastVersionPromptedForStoreReview"
}

#endif
