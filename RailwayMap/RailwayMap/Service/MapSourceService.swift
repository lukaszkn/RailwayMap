//
//  MapSourceService.swift
//  RailwayMap
//
//  Created by Lukasz on 29/05/2024.
//

import MapLibre

class MapSourceService {
    var mapDelegate: MapDelegate?
}

protocol MapDelegate {
    func updateLayers() -> Void
    func getAreaFeatures() -> [MLNFeature]
    func flyToCoordinate(coordinate: CLLocationCoordinate2D)
    func flyToCurrentLocation()
}
