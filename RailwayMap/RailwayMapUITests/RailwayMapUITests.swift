//
//  RailwayMapUITests.swift
//  RailwayMapUITests
//
//  Created by Lukasz on 20/05/2024.
//
// https://blog.winsmith.de/english/ios/2020/04/14/xcuitest-screenshots.html
// https://blog.slaunchaman.com/2020/01/16/automatically-turn-ui-tests-into-screen-recordings/
// https://testableapple.com/video-recording-of-failed-tests-on-ios/
// https://github.com/ChargePoint/xcparse

import XCTest

final class RailwayMapUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
