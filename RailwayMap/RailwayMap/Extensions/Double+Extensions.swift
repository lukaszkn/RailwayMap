//
//  Double+Extensions.swift
//  RailwayMap
//
//  Created by Lukasz on 29/05/2024.
//

import CoreLocation

extension Double {
    
    func distanceLongString() -> String {
        let distanceInMeters: CLLocationDistance = self
        
        if Locale.current.measurementSystem == .metric {
            return NSString(format: "%.1fkm", self / 1000.0) as String
        } else {
            let formatter = MeasurementFormatter()
            return formatter.string(from: Measurement(value: distanceInMeters, unit: UnitLength.meters))
        }
    }
    
}
