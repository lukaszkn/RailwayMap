//
//  MapTabViewModel.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import Foundation

@Observable
class MapTabViewModel {
    var showingMapTapSheet = false
    var showingMapOptions = false
    
    var mapOptions = MapLayerOptions()
    var tapDebugString = ""
    
    func onMapTap(debugString: String) {
        tapDebugString = debugString
        showingMapTapSheet.toggle()
    }
}
