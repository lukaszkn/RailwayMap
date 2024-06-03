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
    
    var globalState: GlobalState
    var mapSourceService: MapSourceService
    
    init() {
        self.globalState = AppDelegate.instance.container.resolve(GlobalState.self)!
        self.mapSourceService = AppDelegate.instance.container.resolve(MapSourceService.self)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation(notification:)), name: .didUpdateLocation, object: nil)
    }
    
    func onAppear() {
        self.areaFeatures = self.mapSourceService.mapDelegate?.getAreaFeatures() ?? []
    }
    
    @objc func didUpdateLocation(notification: NSNotification) {
        let lastLocation = notification.object as! CLLocation
        
        if (self.globalState.mainTabIndex == ContentView.TabIndex.explore.rawValue) {
            self.areaFeatures = self.mapSourceService.mapDelegate?.getAreaFeatures() ?? []
        }
    }
}
