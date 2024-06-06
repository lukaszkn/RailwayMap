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
//
// xcparse screenshots --model --test-plan-config /Users/lukasz/Library/Developer/Xcode/DerivedData/RailwayMap-fcayijcllzsjgccozubjuipqeljl/Logs/Test/Test-RailwayMap-2024.06.06_16-32-52-+0200.xcresult /Users/lukasz/Documents/RailwayMap

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
                CLLocation(latitude: 51.1048786, longitude: 17.0268321), // PL, Wrocław
                CLLocation(latitude: 50.055308, longitude: 19.934861), // tram
                CLLocation(latitude: 49.7103299, longitude: 20.4208239), // disused, Limanowa
                CLLocation(latitude: 50.0135585, longitude: 22.4691828)  // narrow gauge, Przeworsk
            ]
            
            titles = [
                "Mapa kolejowa\noffline", "Wybierz widoczne\nwarstwy", "Zobacz linie\ntramwajowe", "Odkryj tory\nnieużywane", "Poznaj\nwąskotorówki", "Poznaj pobliską\nokolicę"
            ]
            
            app.launchArguments += ["-AppleLanguages", "(pl)"]
            app.launchArguments += ["-AppleLocale", "pl_PL"]
        } else if forLocation == "uk" {
            locations = [
                CLLocation(latitude: 51.513092, longitude: -0.0340145), // uk, Limehouse
                CLLocation(latitude: 52.950491, longitude: -1.1464), // tram
                CLLocation(latitude: 50.8740117, longitude: -1.4125035), // disused, Hythe
                CLLocation(latitude: 52.5847948, longitude: -4.0858234) // narrow gauge
            ]
            
            titles = [
                "World offline\nrailway map", "Choose which\nlayers are visible", "See tramways", "Discover\ndisused tracks", "Check narrow\ngauge line", "Explore\nnearby area"
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
                                
                                self.showDisused(forLocation) {
                                    
                                    app.terminate()
                                    
                                    self.showNarrowGauge(forLocation, app: app) {
                                        
                                        self.showExploreTab(forLocation) {
                                            expectation.fulfill()
                                        }
                                        
                                    }
                                }
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.takeScreenshot(name: "\(forLocation)2")
                self.takeScreenshotWithFrame(name: "\(forLocation)2", title: self.titles[2])
                complete()
            })
        })
    }
    
    func showDisused(_ forLocation: String, complete: @escaping () -> Void) {
        XCUIDevice.shared.location = XCUILocation(location: self.locations[2]) // disused
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["current_location"]/*[[".buttons[\"Location Services\"]",".buttons[\"current_location\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.takeScreenshot(name: "\(forLocation)3")
            self.takeScreenshotWithFrame(name: "\(forLocation)3", title: self.titles[3])
            complete()
        })
    }
    
    func showNarrowGauge(_ forLocation: String, app: XCUIApplication, complete: @escaping () -> Void) {
        app.launchArguments.removeAll { arg in arg == CommandLineDebugAction.mapOptionsTramWithOSM.rawValue }
        app.launchArguments.append(CommandLineDebugAction.setDefaultMapOptions.rawValue)
        app.launchArguments.append(CommandLineDebugAction.mapFlyToAltitude20.rawValue)
        app.launch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            XCUIDevice.shared.location = XCUILocation(location: self.locations[3]) // narrow gauge
            XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["current_location"]/*[[".buttons[\"Location Services\"]",".buttons[\"current_location\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.takeScreenshot(name: "\(forLocation)4")
                self.takeScreenshotWithFrame(name: "\(forLocation)4", title: self.titles[4])
                complete()
            })
        })
    }
    
    func showExploreTab(_ forLocation: String, complete: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            XCUIApplication().tabBars.firstMatch/*@START_MENU_TOKEN@*/.buttons["explore_tab"]/*[[".buttons[\"Explore\"]",".buttons[\"explore_tab\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.takeScreenshot(name: "\(forLocation)5")
                self.takeScreenshotWithFrame(name: "\(forLocation)5", title: self.titles[5])
                complete()
            })
        })
    }
    
    func testRunAppOnly() throws {
        let expectation = expectation(description: "expectation")
        let app = XCUIApplication()
        app.launch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.takeScreenshot(name: "ttt")
            self.takeScreenshotWithFrame(name: "ttt", title: "Test text")
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 50)
    }

    func testScreenshotsForAppStore() throws {
        let expectationUK = expectation(description: "uk")
        screenshots("uk", expectation: expectationUK)
        wait(for: [expectationUK], timeout: 350.0)
        
        let expectationPL = expectation(description: "pl")
        screenshots("pl", expectation: expectationPL)
        wait(for: [expectationPL], timeout: 350.0)
        
//        let expectationUS = expectation(description: "us")
//        screenshots("us", expectation: expectationUS)
//        wait(for: [expectationUS], timeout: 350.0)
    }
}
