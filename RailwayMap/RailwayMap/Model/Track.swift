//
//  Track.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import Foundation

struct Track: Identifiable {
    var id: String { name }
    var routeType: RouteType
    var name: String
    var network: String
    var colour: String
    var wikipedia: String
}

enum RouteType: Int {
    case station = 0
    case subway = 1
    case tram = 2
    case lightRail = 3
    case narrowGauge = 4
    case disused = 5
}
