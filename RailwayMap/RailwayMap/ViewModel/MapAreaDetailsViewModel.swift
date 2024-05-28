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

    init() {
        self.locationService = AppDelegate.instance.container.resolve(LocationService.self)!
    }
    
    func prepareData(features: [MLNFeature]) {
        for feature in features {
            if feature.isKind(of: MLNPointFeature.self) {
                if let nodeType = feature.attribute(forKey: "nt") as? Int,
                   let name = feature.attribute(forKey: "name") as? String,
                   let sid = feature.attribute(forKey: "sid") as? Int64 {
                    
                    let station = Station(id: sid, nodeType: NodeType(rawValue: nodeType)!, name: name, coordinate: feature.coordinate)
                    
                    let exists = stations.contains { $0.id == station.id }
                    if !exists {
                        stations.append(station)
                    }
                }
            }
            else if feature.isKind(of: MLNMultiPolylineFeature.self) {
                if let nodeType = feature.attribute(forKey: "rt") as? Int,
                   let name = feature.attribute(forKey: "name") as? String {
                    
//                    var track = Track()
//                    
//                    let exists = stations.contains { $0.id == station.id }
//                    if !exists {
//                        stations.append(station)
//                    }
                }
            }
        }
        
        stations.sort {
            $0.name < $1.name
        }
        
        tracks.sort {
            $0.name < $1.name
        }
    }
}
