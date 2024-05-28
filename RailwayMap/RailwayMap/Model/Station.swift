//
//  Station.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import Foundation
import CoreLocation

struct Station: Identifiable {
    var id: Int64
    var nodeType: NodeType
    var name: String
    
    var coordinate: CLLocationCoordinate2D
}

enum NodeType: Int {
    case station = 0
    case subway = 1
    case tram = 2
    case lightRail = 3
}
