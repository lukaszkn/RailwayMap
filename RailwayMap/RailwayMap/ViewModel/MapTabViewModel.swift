//
//  MapTabViewModel.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import Foundation
import MapLibre

@Observable
class MapTabViewModel {
    var showingMapTapSheet = false
    var showingMapOptions = false
    
    var mapOptions = MapLayerOptions()
    var tapFeatures: [MLNFeature] = []
    
    var mapSourceService: MapSourceService
    
    init() {
        self.mapSourceService = AppDelegate.instance.container.resolve(MapSourceService.self)!
        
        // load saved map options if present
        if let archievedMapOptions = UserDefaults.standard.object(forKey: UserDefaultsKeys.mapOptions.rawValue) as? Data {
            if let options = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MapLayerOptions.self, from: archievedMapOptions) {
                self.mapOptions = options
            }
        }
    }
    
    func onMapTap(features: [MLNFeature]) {
        tapFeatures = features
        showingMapTapSheet = true
    }
    
    func onLocationButtonTap() {
        self.mapSourceService.mapDelegate?.flyToCurrentLocation()
    }
    
    func onMapOptionsClose() {
        // save map options
        do {
            let archievedMapOptions = try NSKeyedArchiver.archivedData(withRootObject: self.mapOptions, requiringSecureCoding: false)
            UserDefaults.standard.set(archievedMapOptions, forKey: UserDefaultsKeys.mapOptions.rawValue)
            UserDefaults.standard.synchronize()
        } catch {
            print("save map options error \(error)")
        }
        self.mapSourceService.mapDelegate?.updateLayers()
    }
}


