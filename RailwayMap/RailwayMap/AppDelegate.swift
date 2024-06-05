//
//  AppDelegate.swift
//  RailwayMap
//
//  Created by Lukasz on 28/05/2024.
//

import Foundation
import UIKit
import Swinject

class AppDelegate: NSObject, UIApplicationDelegate {
    static private(set) var instance: AppDelegate! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppDelegate.instance = self
        
#if DEBUG || RELEASE_RECORDING
        if CommandLine.arguments.contains(CommandLineDebugAction.setDefaultMapOptions.rawValue) {
            // delete saved map options
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.mapOptions.rawValue)
            
        } else if CommandLine.arguments.contains(CommandLineDebugAction.mapOptionsWithOSM.rawValue) {
            let mapOptions = MapLayerOptions()
            mapOptions.showOpenStreetMap = true
            do {
                let archievedMapOptions = try NSKeyedArchiver.archivedData(withRootObject: mapOptions, requiringSecureCoding: false)
                UserDefaults.standard.set(archievedMapOptions, forKey: UserDefaultsKeys.mapOptions.rawValue)
                UserDefaults.standard.synchronize()
            } catch {
                print("AppDelegate save map options error \(error)")
            }
        } else if CommandLine.arguments.contains(CommandLineDebugAction.mapOptionsTramWithOSM.rawValue) {
            let mapOptions = MapLayerOptions()
            mapOptions.showOpenStreetMap = true
            mapOptions.showRailways = false
            mapOptions.showSubways = false
            mapOptions.showNarrowGauge = false
            mapOptions.showTramways = true
            mapOptions.showLightRailways = false
            mapOptions.showDisused = false
            
            mapOptions.showRailwayStations = false
            mapOptions.showSubwayStations = false
            mapOptions.showTramStops = true
            mapOptions.showLightRailwayStations = false
            do {
                let archievedMapOptions = try NSKeyedArchiver.archivedData(withRootObject: mapOptions, requiringSecureCoding: false)
                UserDefaults.standard.set(archievedMapOptions, forKey: UserDefaultsKeys.mapOptions.rawValue)
                UserDefaults.standard.synchronize()
            } catch {
                print("AppDelegate save map options error \(error)")
            }
        }
#endif
        
        return true
    }
    
    let container: Container = {
        let container = Container()
        
        container.register(LocationService.self) { _ in LocationService() }.inObjectScope(.container)
        container.register(MapSourceService.self) { _ in MapSourceService() }.inObjectScope(.container)
        container.register(GlobalState.self) { _ in GlobalState() }.inObjectScope(.container)
        
        return container
    }()
}
