//
//  MapAreaDetailsViewModel.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import Foundation
import MapLibre

@Observable
class MapAreaDetailsViewModel {
    var stations: [Station] = []
    var tracks: [Track] = []
    
    var locationService: LocationService
    var mapSourceService: MapSourceService

    init() {
        self.locationService = AppDelegate.instance.container.resolve(LocationService.self)!
        self.mapSourceService = AppDelegate.instance.container.resolve(MapSourceService.self)!
    }
    
    func prepareData(features: [MLNFeature]) {
        stations.removeAll()
        tracks.removeAll()
        
        for feature in features {
            if feature.isKind(of: MLNPointFeature.self) {
                if let nodeType = feature.attribute(forKey: "nt") as? Int,
                   let name = feature.attribute(forKey: "name") as? String,
                   let sid = feature.attribute(forKey: "sid") as? Int64 {
                    
                    var station = Station(id: sid, nodeType: NodeType(rawValue: nodeType)!, name: name, coordinate: feature.coordinate)
                    
                    if let colour = feature.attribute(forKey: "colour") as? String {
                        station.colour = colour
                    }
                    
                    if let line = feature.attribute(forKey: "line") as? String {
                        station.line = line
                    }
                    
                    let exists = stations.contains { $0.id == station.id }
                    if !exists {
                        stations.append(station)
                    }
                }
            }
            else if feature.isKind(of: MLNMultiPolylineFeature.self) {
                if let routeType = feature.attribute(forKey: "rt") as? Int,
                   let name = feature.attribute(forKey: "name") as? String {
                    
                    var track = Track(routeType: RouteType(rawValue: routeType)!, name: name)
                    
                    if let colour = feature.attribute(forKey: "colour") as? String {
                        track.colour = colour
                    }
                    
                    if let network = feature.attribute(forKey: "network") as? String {
                        track.network = network
                    }
                    
                    if let wikipedia = feature.attribute(forKey: "wikipedia") as? String {
                        track.wikipedia = wikipedia
                    }

                    let exists = tracks.contains { $0.name == track.name && $0.routeType == track.routeType && $0.network == track.network }
                    if !exists {
                        tracks.append(track)
                    }
                } else if let wayType = feature.attribute(forKey: "wt") as? Int {
                    
                    var track: Track
                    
                    let name = feature.attribute(forKey: "name") as? String
                    let network = feature.attribute(forKey: "network") as? String
                    
                    if let name, let network {
                        track = Track(routeType: RouteType(rawValue: wayType)!, name: name)
                        track.network = network
                    } else if let name {
                        track = Track(routeType: RouteType(rawValue: wayType)!, name: name)
                    } else if let network {
                        track = Track(routeType: RouteType(rawValue: wayType)!, name: network)
                    } else {
                        continue
                    }
                    
                    if let wikipedia = feature.attribute(forKey: "wikipedia") as? String {
                        track.wikipedia = wikipedia
                    }

                    let exists = tracks.contains { $0.name == track.name && $0.routeType == track.routeType && $0.network == track.network }
                    if !exists {
                        tracks.append(track)
                    }
                }
            }
        }
        
        stations = stations.sorted { (lhs: Station, rhs: Station) -> Bool in
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
        
        tracks = tracks.sorted { (lhs: Track, rhs: Track) -> Bool in
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
}
