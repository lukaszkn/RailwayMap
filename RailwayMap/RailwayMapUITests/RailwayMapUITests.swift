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
    var locations: [CLLocation] = []
    
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
                                               font: .system(size: 150, weight: .semibold, design: .rounded))
        
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
        app.launchArguments.removeAll()
        app.launchArguments.append(CommandLineDebugAction.setDefaultMapOptions.rawValue)
        
        var locations: [CLLocation] = []
        if forLocation == "pl" {
            locations = [
                CLLocation(latitude: 50.055308, longitude: 19.934861), // PL
            ]
            
            titles = [
                "Mapa kolejowa\noffline", "Choose which\nlayers are visible", "See tramways", "Check narrow\ngauge line", "Discover\ndisused tracks", "Explore\nnearby area"
            ]
            
            app.launchArguments += ["-AppleLanguages", "(pl)"]
            app.launchArguments += ["-AppleLocale", "pl_PL"]
        } else if forLocation == "uk" {
            locations = [
                CLLocation(latitude: 52.950491, longitude: -1.1464), // uk
                CLLocation(latitude: 52.950491, longitude: -1.1464)
            ]
            
            titles = [
                "World offline\nrailway map", "Choose which\nlayers are visible", "See tramways", "Check narrow\ngauge line", "Discover\ndisused tracks", "Explore\nnearby area"
            ]
            
            app.launchArguments += ["-AppleLanguages", "(en)"]
            app.launchArguments += ["-AppleLocale", "en_GB"]
        } else if forLocation == "us" {
            
            app.launchArguments += ["-AppleLanguages", "(en)"]
            app.launchArguments += ["-AppleLocale", "en_US"]
        }
        return locations
    }
    
//    func continueScreenshots(_ forLocation: String, expectation: XCTestExpectation, app: XCUIApplication, saveScreenshots: Bool) {
//        let locations = self.setupLocations(forLocation, app: app)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            self.scheduleLocationUpdates(forLocation, locations: locations, complete: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                    expectation.fulfill()
//                })
//            })
//        })
//    }
    
    func screenshots(_ forLocation: String, expectation: XCTestExpectation, saveScreenshots: Bool = true) {
        let app = XCUIApplication()
        
        self.locations = self.setupLocations(forLocation, app: app)

        app.launch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            XCUIDevice.shared.location = XCUILocation(location: self.locations[0])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["current_location"]/*[[".buttons[\"Location Services\"]",".buttons[\"current_location\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.takeScreenshot(name: "\(forLocation)0")
                    self.takeScreenshotWithFrame(name: "\(forLocation)0", title: self.titles[0])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.showMapOptions(forLocation) {
                            
                            //XCUIApplication().navigationBars["Map options"].staticTexts["Map options"].swipeDown()
                            
                            app.terminate()
                            
                            self.showTramWithOSM(forLocation, app: app) {
                                expectation.fulfill()
                            }
                            
                            
                        }
                    })
                })
            })
        })
    }
    
    func showMapOptions(_ forLocation: String, complete: @escaping () -> Void) {
        XCUIApplication().buttons["square.2.layers.3d"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            self.takeScreenshot(name: "\(forLocation)1")
            self.takeScreenshotWithFrame(name: "\(forLocation)1", title: self.titles[1])
            complete()
        })
    }
    
    func showTramWithOSM(_ forLocation: String, app: XCUIApplication, complete: @escaping () -> Void) {
        app.launchArguments.removeAll { arg in arg == CommandLineDebugAction.setDefaultMapOptions.rawValue }
        app.launchArguments.append(CommandLineDebugAction.mapOptionsTramWithOSM.rawValue)
        
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            XCUIDevice.shared.location = XCUILocation(location: self.locations[1])
            XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["current_location"]/*[[".buttons[\"Location Services\"]",".buttons[\"current_location\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.takeScreenshot(name: "\(forLocation)2")
                self.takeScreenshotWithFrame(name: "\(forLocation)2", title: self.titles[2])
                complete()
            })
        })
    }

    func testScreenshotsForAppStore() throws {
//        let expectationPL = expectation(description: "pl")
//        screenshots("pl", expectation: expectationPL)
//        wait(for: [expectationPL], timeout: 350.0)
        
        let expectationUK = expectation(description: "uk")
        screenshots("uk", expectation: expectationUK)
        wait(for: [expectationUK], timeout: 350.0)
        //XCUIApplication().tabBars["Tab Bar"].buttons["Explore"].tap()
        XCUIApplication().tabBars["Tab Bar"]/*@START_MENU_TOKEN@*/.buttons["explore_tab"]/*[[".buttons[\"Explore\"]",".buttons[\"explore_tab\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
//        let expectationUS = expectation(description: "us")
//        screenshots("us", expectation: expectationUS)
//        wait(for: [expectationUS], timeout: 350.0)
    }
}
