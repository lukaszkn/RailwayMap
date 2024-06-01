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
    }
    
    func onMapTap(features: [MLNFeature]) {
        tapFeatures = features
        showingMapTapSheet = true
    }
    
    func onLocationButtonTap() {
        let locationService = AppDelegate.instance.container.resolve(LocationService.self)!
        if let lastLocation = locationService.lastLocation {
            self.mapSourceService.mapDelegate?.flyToCoordinate(coordinate: lastLocation.coordinate)
        }
    }
}


