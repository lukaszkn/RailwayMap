//
//  MapLayerOptions.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import Foundation

class MapLayerOptions: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(showOpenStreetMap, forKey: "showOpenStreetMap")
        
        coder.encode(showRailways, forKey: "showRailways")
        coder.encode(showSubways, forKey: "showSubways")
        coder.encode(showNarrowGauge, forKey: "showNarrowGauge")
        coder.encode(showTramways, forKey: "showTramways")
        coder.encode(showLightRailways, forKey: "showLightRailways")
        coder.encode(showDisused, forKey: "showDisused")
        
        coder.encode(showRailwayStations, forKey: "showRailwayStations")
        coder.encode(showSubwayStations, forKey: "showSubwayStations")
        coder.encode(showTramStops, forKey: "showTramStops")
        coder.encode(showLightRailwayStations, forKey: "showLightRailwayStations")
    }
    
    required init?(coder: NSCoder) {
        showOpenStreetMap = coder.decodeBool(forKey: "showOpenStreetMap")
        
        showRailways = coder.decodeBool(forKey: "showRailways")
        showSubways = coder.decodeBool(forKey: "showSubways")
        showNarrowGauge = coder.decodeBool(forKey: "showNarrowGauge")
        showTramways = coder.decodeBool(forKey: "showTramways")
        showLightRailways = coder.decodeBool(forKey: "showLightRailways")
        showDisused = coder.decodeBool(forKey: "showDisused")
        
        showRailwayStations = coder.decodeBool(forKey: "showRailwayStations")
        showSubwayStations = coder.decodeBool(forKey: "showSubwayStations")
        showTramStops = coder.decodeBool(forKey: "showTramStops")
        showLightRailwayStations = coder.decodeBool(forKey: "showLightRailwayStations")
    }
    
    override init() {
        super.init()
    }
    
    var showOpenStreetMap = false
    
    var showRailways = true
    var showSubways = true
    var showNarrowGauge = true
    var showTramways = true
    var showLightRailways = true
    var showDisused = false
    
    var showRailwayStations = true
    var showSubwayStations = true
    var showTramStops = true
    var showLightRailwayStations = true
    
    static var flyToAltitude = 10_000.0
}
