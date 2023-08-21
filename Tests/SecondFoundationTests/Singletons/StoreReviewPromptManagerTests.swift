//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import SecondFoundation
import XCTest


final class StoreReviewPromptManagerTests: XCTestCase {
    var reviewPromptManager: StoreReviewPromptManager!

    override func setUp() {
        super.setUp()
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        reviewPromptManager = StoreReviewPromptManager(promptThreshold: 5)
    }

    override func tearDown() {
        reviewPromptManager = nil
        super.tearDown()
    }

    func testKarmaInitialization() {
        XCTAssertEqual(reviewPromptManager.karma, 0)
    }

    func testKarmaChangeAction() {
        reviewPromptManager.onKarmaChange { karma in
            XCTAssertEqual(karma, 2)
        }
        reviewPromptManager.logPoints(for: .init(points: 2))
    }

    func testPromptThresholdNotReached() {
        reviewPromptManager.logPoints(for: .init(points: 3))
        XCTAssertEqual(reviewPromptManager.karma, 3)
    }

    func testPromptThresholdReached() {
        reviewPromptManager.onWillPromptForReview { version in
            XCTAssertNil(version)
        }
        reviewPromptManager.logPoints(for: .init(points: 5))
        XCTAssertEqual(reviewPromptManager.karma, 0)
    }
}
