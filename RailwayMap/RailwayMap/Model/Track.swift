//
//  Track.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import SwiftUI

struct Track: Identifiable {
    var id: String { name }
    var routeType: RouteType
    var name: String
    
    var network: String?
    var colour: String?
    var wikipedia: String?
    
    var secondaryDescriptionLine: String {
        var text = self.routeType.typeString()
        if let network {
            text += ", \(network)"
        }
        return text
    }
    
    var wikiUrl: URL? {
        if let wiki = self.wikipedia, let wikiUrlEncoded = wiki.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            var urlString = "https://wikipedia.org/wiki/\(wikiUrlEncoded)"
            return URL(string: urlString)
        } else {
            return nil
        }
    }
}

enum RouteType: Int {
    case railway = 0
    case subway = 1
    case tram = 2
    case lightRail = 3
    case narrowGauge = 4
    case disused = 5
    
    func typeColour() -> Color {
        switch self {
        case .subway: return Color.tracksSubways
        case .tram: return Color.tracksSubways
        case .lightRail: return Color.tracksLightRailways
        case .narrowGauge: return Color.tracksNarrowGauge
        case .disused: return Color.tracksDisused
        default:
            return Color.tracksRailways
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
        case .narrowGauge:
            return "Narrow gauge"
        case .disused:
            return "Disused"
        default:
            return "Railway"
        }
    }
}
