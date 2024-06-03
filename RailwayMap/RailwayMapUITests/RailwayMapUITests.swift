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
import SwiftUI
import CoreLocation

final class RailwayMapUITests: XCTestCase {
    
    var titles: [String] = []
    
    func scheduleLocationUpdates(_ forLocation: String, locations: [CLLocation], complete: @escaping () -> Void) {
        var delay = 0.5
        for locationIdx in 0 ..< locations.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                XCUIDevice.shared.location = XCUILocation(location: locations[locationIdx])
                
                XCUIApplication().buttons["Location Services"].tap()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.takeScreenshot(name: "\(forLocation)\(locationIdx)")
                    self.takeScreenshotWithFrame(name: "\(forLocation)\(locationIdx)", title: self.titles[locationIdx])
                })
            })
            delay += 1 + 3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            complete()
        })
    }
    
    func takeScreenshot(name: String) {
        let screenshot = XCTAttachment(screenshot: XCUIApplication().screenshot())
        screenshot.name = "screenshot_\(name)_\(UIDevice.current.name)"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    
    func takeScreenshotWithFrame(name: String, title: String) {
        var exportSize = ExportSize.iPhone_6_5_Inches
        
        let deviceName = UIDevice.current.name
        if deviceName == "iPhone 15 Pro Max" {
            exportSize = ExportSize.iPhone_6_7_Inches
        } else if deviceName.contains("iPad Pro") {
            exportSize = ExportSize.iPadPro_12_9_Inches
        } else if deviceName == "iPhone SE (3rd generation)" {
            exportSize = ExportSize.iPhone_5_5_Inches
        }
        
        let screenshot = XCUIApplication().screenshot()
        let capuringView = ScreenshotWithTitle(title: title,
                                               image: Image(uiImage: screenshot.image),
                                               background: .deviceFrame(Color.init(withHex: 0xF7F3E6)),
                                               exportSize: exportSize,
                                               font: .system(size: 150, weight: .semibold))
        
        let attachment = createMarketing(image: capuringView, exportSize: exportSize)
        attachment.name = "screenshot_\(name)_\(UIDevice.current.name)_framed"
        add(attachment)
        
//        if exportSize == ExportSize.iPhone_6_5_Inches {
//            exportSize = ExportSize.iPhone_6_7_Inches
//            let screenshot = XCUIApplication().screenshot()
//            let capuringView = ScreenshotWithTitle(title: "Title \(name)",
//                                                   image: Image(uiImage: screenshot.image),
//                                                   background: .deviceFrame(Color.init(withHex: 0xF7F3E6)),
//                                                   exportSize: exportSize)
//            
//            let attachment = createMarketing(image: capuringView, exportSize: exportSize)
//            attachment.name = "screenshot_\(name)_iPhone 15 Pro Max_framed"
//            add(attachment)
//        }
    }
    
    func setupLocations(_ forLocation: String, app: XCUIApplication) -> [CLLocation] {
        var locations: [CLLocation] = []
        if forLocation == "pl" {
            locations = [
                CLLocation(latitude: 50.055308, longitude: 19.934861), // PL
            ]
            
            titles = [
                "World offline\nrailway map"
            ]
            
            app.launchArguments += ["-AppleLanguages", "(pl)"]
            app.launchArguments += ["-AppleLocale", "pl_PL"]
        }
        return locations
    }
    
    func continueScreenshots(_ forLocation: String, expectation: XCTestExpectation, app: XCUIApplication, saveScreenshots: Bool) {
        let locations = self.setupLocations(forLocation, app: app)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.scheduleLocationUpdates(forLocation, locations: locations, complete: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    expectation.fulfill()
                })
            })
        })
    }
    
    func screenshots(_ forLocation: String, expectation: XCTestExpectation, saveScreenshots: Bool = true) {
        let app = XCUIApplication()
        app.launch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            XCUIDevice.shared.location = XCUILocation(location: self.setupLocations(forLocation, app: app)[0])
            self.continueScreenshots(forLocation, expectation: expectation, app: app, saveScreenshots: saveScreenshots)
        })
    }

    func testScreenshotsForAppStore() throws {
        let expectationPL = expectation(description: "pl")
        screenshots("pl", expectation: expectationPL)
        wait(for: [expectationPL], timeout: 350.0)
        
//        let expectationUK = expectation(description: "uk")
//        screenshots("uk", expectation: expectationUK)
//        wait(for: [expectationUK], timeout: 350.0)
//        
//        let expectationUS = expectation(description: "us")
//        screenshots("us", expectation: expectationUS)
//        wait(for: [expectationUS], timeout: 350.0)
    }
}
