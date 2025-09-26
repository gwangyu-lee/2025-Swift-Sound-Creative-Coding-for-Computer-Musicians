//
//  _8_iOS_X_Computer_Music_ProjectUITestsLaunchTests.swift
//  08-iOS-X-Computer-Music-ProjectUITests
//
//  Created by Gwangyu Lee on 9/26/25.
//

import XCTest

final class _8_iOS_X_Computer_Music_ProjectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
