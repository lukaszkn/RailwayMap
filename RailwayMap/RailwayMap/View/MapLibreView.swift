//
//  MapLibreView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import MapLibre
import MapKit
import SwiftUI

struct MapLibreView: UIViewRepresentable {
    var viewModel: MapTabViewModel
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        
        let singleTap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleMapTap(sender:))
        )
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        
        mapView.setCenter(CLLocationCoordinate2DMake(52.2, 19.1), zoomLevel: 7, animated: false)
        mapView.delegate = context.coordinator
        mapView.maximumZoomLevel = 18
        mapView.logoView.isHidden = true
        
#if DEBUG
        mapView.allowsRotating = false
#endif
        
        return mapView
    }
    
    func updateUIView(_ mapView: MLNMapView, context: Context) {
        print("MapLibreView updateUIView")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate, MapDelegate {
        var mapView: MLNMapView?
        var viewModel: MapTabViewModel
        
        let osmTileSource: MLNRasterTileSource
        let osmRasterStyleLayer: MLNRasterStyleLayer
        let railwaysSource: MLNVectorTileSource
        
        let tracksRailwayLayer: MLNLineStyleLayer
//        let tracksLightRailwayLayer: MLNLineStyleLayer
        let tracksNarrowGaugeLayer: MLNLineStyleLayer
//        let tracksSubwayLayer: MLNLineStyleLayer
//        let tracksTramwayLayer: MLNLineStyleLayer
//        let tracksDisusedLayer: MLNLineStyleLayer
        
        var pannedToUserLocation = false
        
        init(viewModel: MapTabViewModel) {
            self.viewModel = viewModel
            
            osmTileSource = MLNRasterTileSource(identifier: "osm", tileURLTemplates: ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"], options: [
                .minimumZoomLevel: 5,
                .maximumZoomLevel: 16,
                .tileSize: 256,
                .attributionInfos: [
                    MLNAttributionInfo(title: NSAttributedString(string: "© OpenStreetMap contributors."), url: URL(string: "https://openstreetmap.org"))
                ]
            ])
            
            osmRasterStyleLayer = MLNRasterStyleLayer(identifier: "osm", source: osmTileSource)
            osmRasterStyleLayer.minimumRasterBrightness = NSExpression(forConstantValue: 0.25)
            
            let mbURL = "mbtiles:///\(Bundle.main.url(forResource: "poland", withExtension: "mbtiles")!.path())"
            railwaysSource = MLNVectorTileSource(identifier: "railway", tileURLTemplates: [mbURL], options: [
                .minimumZoomLevel: 4,
                .maximumZoomLevel: 12,
                .attributionInfos: [
                    MLNAttributionInfo(title: NSAttributedString(string: "© MapLibre"), url: URL(string: "https://maplibre.org"))
                ]
            ])
            
            // add layer representing railway tracks
            tracksRailwayLayer = MLNLineStyleLayer(identifier: "railway", source: railwaysSource)
            tracksRailwayLayer.sourceLayerIdentifier = "railway"
            tracksRailwayLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            tracksRailwayLayer.lineWidth = NSExpression(forConstantValue: 2)
            
            tracksNarrowGaugeLayer = MLNLineStyleLayer(identifier: "narrow_gauge", source: railwaysSource)
            tracksNarrowGaugeLayer.sourceLayerIdentifier = "narrow_gauge"
            tracksNarrowGaugeLayer.lineColor = NSExpression(forConstantValue: UIColor.green)
            tracksNarrowGaugeLayer.lineWidth = NSExpression(forConstantValue: 2)
            
            super.init()
            
            self.viewModel.mapDelegate = self
        }
        
        // add sources and layers after loading default style, mapView.style is nil prior to this
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            self.mapView = mapView
            
            mapView.style?.addSource(railwaysSource)
            
            
            updateLayers()
            
            mapView.style?.addLayer(osmRasterStyleLayer)
            
            mapView.style?.addLayer(tracksRailwayLayer)
            
            
            let tracksNarrowGaugeLayerBackground = MLNLineStyleLayer(identifier: "narrow_gauge_background", source: railwaysSource)
            tracksNarrowGaugeLayerBackground.sourceLayerIdentifier = "narrow_gauge"
            tracksNarrowGaugeLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksNarrowGaugeLayerBackground.lineWidth = NSExpression(forConstantValue: 5)
            mapView.style?.addLayer(tracksNarrowGaugeLayerBackground)
            
            mapView.style?.addLayer(tracksNarrowGaugeLayer)
            
            // add layer with train stations
            let stationsLayer = MLNCircleStyleLayer(identifier: "railway_station", source: railwaysSource)
            stationsLayer.sourceLayerIdentifier = "railway_station"
            stationsLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
            //stationsLayer.circleRadius = NSExpression(forConstantValue: 1) https://docs.maptiler.com/maplibre-gl-native-ios/predicates-and-expressions/
            mapView.style?.addLayer(stationsLayer)
            
            let stationNameLayer = MLNSymbolStyleLayer(identifier: "railway_station_name", source: railwaysSource)
            stationNameLayer.sourceLayerIdentifier = "railway_station_name"
            stationNameLayer.text = NSExpression(forKeyPath: "name")
            stationNameLayer.textHaloColor = NSExpression(forConstantValue: UIColor.white)
            stationNameLayer.textHaloWidth = NSExpression(forConstantValue: 2)
            mapView.style?.addLayer(stationNameLayer)
            
            
        }
        
        // Get features at tap point
        @objc func handleMapTap(sender: UITapGestureRecognizer) {
            guard let mapView = sender.view as? MLNMapView else { return }
            
            let tapPoint: CGPoint = sender.location(in: mapView)
            let tapSize = 20.0
            let features = mapView.visibleFeatures(in: CGRect(x: tapPoint.x - tapSize / 2, y: tapPoint.y - tapSize / 2, width: tapSize, height: tapSize))
            print(features)
            self.viewModel.onMapTap(features: features)
        }
        
        func updateLayers() {
            print("updateLayers")
            
            if let mapView = mapView, let style = mapView.style {
                
                let containsOsmTileSource = style.sources.contains(osmTileSource)
                if viewModel.mapOptions.showOpenStreetMap && !containsOsmTileSource {
                    style.addSource(osmTileSource)
                } else if !viewModel.mapOptions.showOpenStreetMap && containsOsmTileSource {
                    style.removeSource(osmTileSource)
                }
                
                osmRasterStyleLayer.isVisible = viewModel.mapOptions.showOpenStreetMap
            }
        }
        
        func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {
            if pannedToUserLocation {
                return
            }
            guard let userLocation = mapView.userLocation else {
                print("User location is currently not available.")
                return
            }
            
            mapView.fly(to: MLNMapCamera(lookingAtCenter: userLocation.coordinate, altitude: 100_000, pitch: 0, heading: 0))
            pannedToUserLocation = true
        }
        
        func mapView(_ mapView: MLNMapView, didChangeLocationManagerAuthorization manager: any MLNLocationManager) {
            print("mapView didChangeLocationManagerAuthorization")
            
            guard let accuracySetting = manager.accuracyAuthorization else {
                return
            }
            let authorizationStatus = manager.authorizationStatus
            print("status \(authorizationStatus)")
            
            if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            }
            
            switch accuracySetting() {
            case .fullAccuracy:
                print("fullAccuracy")
            case .reducedAccuracy:
                print("reducedAccuracy")
            @unknown default:
                print("unknown")
            }
            
            
        }
    }
}
