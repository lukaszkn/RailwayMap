//
//  ExploreTabViewModel.swift
//  RailwayMap
//
//  Created by Lukasz on 29/05/2024.
//

import MapLibre

@Observable
class ExploreTabViewModel {
    var areaFeatures: [MLNFeature] = []
    
    var mapSourceService: MapSourceService
    
    init() {
        self.mapSourceService = AppDelegate.instance.container.resolve(MapSourceService.self)!
    }
    
    func onAppear() {
        self.areaFeatures = self.mapSourceService.mapDelegate?.getAreaFeatures() ?? []
    }
}
