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
        
        return true
    }
    
    let container: Container = {
        let container = Container()
        
        container.register(LocationService.self) { _ in LocationService() }.inObjectScope(.container)
        
        return container
    }()
}
