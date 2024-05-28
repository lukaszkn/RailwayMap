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
    
    var mapDelegate: MapDelegate?
    
    init() {
        
    }
    
    func onMapTap(features: [MLNFeature]) {
        tapFeatures = features
        showingMapTapSheet = true
    }
}

protocol MapDelegate {
    func updateLayers() -> Void
}
