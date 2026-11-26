//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

#if os(iOS) || os(macOS)

@testable import SecondFoundation

import Foundation
import Testing


@Suite("StoreReviewPromptManager Tests", .serialized)
struct StoreReviewPromptManagerTests {
    
    // MARK: Private
    
    private let reviewPromptManager: StoreReviewPromptManager
    
    // MARK: Lifecycle
    
    init() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        reviewPromptManager = StoreReviewPromptManager(promptThreshold: 5)
    }
    
    // MARK: Tests
    
    @Test("Karma starts at zero")
    func karmaInitialization() {
        #expect(reviewPromptManager.karma == 0)
    }
    
    @Test("Logging points reports the new karma to the change action")
    func karmaChangeAction() async {
        var reportedKarma: Int?
        reviewPromptManager.onKarmaChange { karma in
            reportedKarma = karma
        }
        
        reviewPromptManager.logPoints(for: .init(points: 2))
        
        #expect(reportedKarma == 2)
    }
    
    @Test("Karma accumulates while below the prompt threshold")
    func promptThresholdNotReached() async {
        reviewPromptManager.logPoints(for: .init(points: 3))
        
        #expect(reviewPromptManager.karma == 3)
    }
    
    @Test("Reaching the threshold reports karma to the prompt action, then resets karma")
    func promptThresholdReached() async {
        var promptedKarma: Int?
        reviewPromptManager.onWillPromptForReview { _, karma in
            promptedKarma = karma
        }
        
        reviewPromptManager.logPoints(for: .init(points: 5))
        
        #expect(promptedKarma == 5)
        #expect(reviewPromptManager.karma == 0)
    }
}

#endif
