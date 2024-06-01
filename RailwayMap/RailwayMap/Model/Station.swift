//
//  Station.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import SwiftUI
import CoreLocation

struct Station: Identifiable {
    var id: Int64
    var nodeType: NodeType
    var name: String
    
    var colour: String? // Ursynów colour=blue https://www.openstreetmap.org/node/3390304927
    var line: String? // Acton Town line=District;Piccadilly https://www.openstreetmap.org/node/5183843299
    
    var coordinate: CLLocationCoordinate2D
    
    func distanceString(location: CLLocation?) -> String {
        guard let location else { return "" }
        
        let distance = location.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        return distance.distanceLongString()
    }
    
    var secondaryDescriptionLine: String {
        var text = self.nodeType.typeString()
        if let line {
            text += ", \(line)"
        }
        return text
    }
}

enum NodeType: Int {
    case station = 0
    case subway = 1
    case tram = 2
    case lightRail = 3
    
    func typeColour() -> Color {
        switch self {
        case .station:
            return Color.stationRailway
        case .subway:
            return Color.stationSubway
        case .tram:
            return Color.stationTram
        case .lightRail:
            return Color.stationLightRailway
        }
    }
    
    func typeString() -> String {
        switch self {
        case .subway:
            return "Subway"
        case .tram:
            return "Tram"
        case .lightRail:
            return "Light rail"
        default:
            return "Railway"
        }
    }
}
