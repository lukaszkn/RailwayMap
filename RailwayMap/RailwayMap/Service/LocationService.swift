//
//  LocationService.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    private var locManager = CLLocationManager()
    
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locManager.pausesLocationUpdatesAutomatically = true
        locManager.distanceFilter = 10
        
        self.lastLocation = locManager.location
        
        locManager.delegate = self
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            self.lastLocation = locations[0]
            NotificationCenter.default.post(name: .didUpdateLocation, object: self.lastLocation)
        }
    }
}
