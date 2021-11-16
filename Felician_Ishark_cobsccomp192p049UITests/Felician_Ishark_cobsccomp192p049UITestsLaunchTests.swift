//
//  Felician_Ishark_cobsccomp192p049UITestsLaunchTests.swift
//  Felician_Ishark_cobsccomp192p049UITests
//
//  Created by Felician Ishark on 2021-11-12.
//

import XCTest

class Felician_Ishark_cobsccomp192p049UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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
