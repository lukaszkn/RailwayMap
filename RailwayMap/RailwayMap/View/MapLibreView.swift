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
        mapView.attributionButtonPosition = .bottomLeft
        
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
        var mapSourceService: MapSourceService
        
        let osmTileSource: MLNRasterTileSource
        let osmRasterStyleLayer: MLNRasterStyleLayer
        let railwaysSource: MLNVectorTileSource
        
        let tracksRailwayLayer: MLNLineStyleLayer
        let tracksLightRailwayLayer: MLNLineStyleLayer
        let tracksNarrowGaugeLayer: MLNLineStyleLayer
        let tracksSubwayLayer: MLNLineStyleLayer
        let tracksTramwayLayer: MLNLineStyleLayer
        let tracksDisusedLayer: MLNLineStyleLayer
        
        let tracksRailwayLayerBackground: MLNLineStyleLayer
        let tracksLightRailwayLayerBackground: MLNLineStyleLayer
        let tracksNarrowGaugeLayerBackground: MLNLineStyleLayer
        let tracksSubwayLayerBackground: MLNLineStyleLayer
        let tracksTramwayLayerBackground: MLNLineStyleLayer
        let tracksDisusedLayerBackground: MLNLineStyleLayer
        
        let railwayStationLayer: MLNCircleStyleLayer
        let tramStopLayer: MLNCircleStyleLayer
        let subwayStationLayer: MLNCircleStyleLayer
        let lightRailwayStationLayer: MLNCircleStyleLayer
        
        let railwayStationNameLayer: MLNSymbolStyleLayer
        let tramStopNameLayer: MLNSymbolStyleLayer
        let subwayStationNameLayer: MLNSymbolStyleLayer
        let lightRailwayStationNameLayer: MLNSymbolStyleLayer
        
        var pannedToUserLocation = false
        
        init(viewModel: MapTabViewModel) {
            self.viewModel = viewModel
            self.mapSourceService = AppDelegate.instance.container.resolve(MapSourceService.self)!
            
            osmTileSource = MLNRasterTileSource(identifier: "osm", tileURLTemplates: ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"], options: [
                .minimumZoomLevel: 5,
                .maximumZoomLevel: 16,
                .tileSize: 256,
                .attributionInfos: [
                    MLNAttributionInfo(title: NSAttributedString(string: "© OpenStreetMap contributors"), url: URL(string: "https://openstreetmap.org"))
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
            
            let lineWidth = 2
            let backgroundLineWidth = 5
            
            // add layer representing railway tracks
            tracksRailwayLayer = MLNLineStyleLayer(identifier: "railway", source: railwaysSource)
            tracksRailwayLayer.sourceLayerIdentifier = "railway"
            tracksRailwayLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksRailways))
            tracksRailwayLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksRailwayLayerBackground = MLNLineStyleLayer(identifier: "railway_background", source: railwaysSource)
            tracksRailwayLayerBackground.sourceLayerIdentifier = tracksRailwayLayer.sourceLayerIdentifier
            tracksRailwayLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksRailwayLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            tracksNarrowGaugeLayer = MLNLineStyleLayer(identifier: "narrow_gauge", source: railwaysSource)
            tracksNarrowGaugeLayer.sourceLayerIdentifier = "narrow_gauge"
            tracksNarrowGaugeLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksNarrowGauge))
            tracksNarrowGaugeLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksNarrowGaugeLayerBackground = MLNLineStyleLayer(identifier: "narrow_gauge_background", source: railwaysSource)
            tracksNarrowGaugeLayerBackground.sourceLayerIdentifier = tracksNarrowGaugeLayer.sourceLayerIdentifier
            tracksNarrowGaugeLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksNarrowGaugeLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            tracksTramwayLayer = MLNLineStyleLayer(identifier: "tram", source: railwaysSource)
            tracksTramwayLayer.sourceLayerIdentifier = "tram"
            tracksTramwayLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksTramways))
            tracksTramwayLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksTramwayLayerBackground = MLNLineStyleLayer(identifier: "tram_background", source: railwaysSource)
            tracksTramwayLayerBackground.sourceLayerIdentifier = tracksTramwayLayer.sourceLayerIdentifier
            tracksTramwayLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksTramwayLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            tracksLightRailwayLayer = MLNLineStyleLayer(identifier: "light_railway", source: railwaysSource)
            tracksLightRailwayLayer.sourceLayerIdentifier = "light_railway"
            tracksLightRailwayLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksLightRailways))
            tracksLightRailwayLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksLightRailwayLayerBackground = MLNLineStyleLayer(identifier: "light_railway_background", source: railwaysSource)
            tracksLightRailwayLayerBackground.sourceLayerIdentifier = tracksLightRailwayLayer.sourceLayerIdentifier
            tracksLightRailwayLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksLightRailwayLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            tracksSubwayLayer = MLNLineStyleLayer(identifier: "subway", source: railwaysSource)
            tracksSubwayLayer.sourceLayerIdentifier = "subway"
            tracksSubwayLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksSubways))
            tracksSubwayLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksSubwayLayerBackground = MLNLineStyleLayer(identifier: "subway_background", source: railwaysSource)
            tracksSubwayLayerBackground.sourceLayerIdentifier = tracksSubwayLayer.sourceLayerIdentifier
            tracksSubwayLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksSubwayLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            tracksDisusedLayer = MLNLineStyleLayer(identifier: "disused", source: railwaysSource)
            tracksDisusedLayer.sourceLayerIdentifier = "disused"
            tracksDisusedLayer.lineColor = NSExpression(forConstantValue: UIColor(Color.tracksDisused))
            tracksDisusedLayer.lineWidth = NSExpression(forConstantValue: lineWidth)
            
            tracksDisusedLayerBackground = MLNLineStyleLayer(identifier: "disused_background", source: railwaysSource)
            tracksDisusedLayerBackground.sourceLayerIdentifier = tracksDisusedLayer.sourceLayerIdentifier
            tracksDisusedLayerBackground.lineColor = NSExpression(forConstantValue: UIColor.white)
            tracksDisusedLayerBackground.lineWidth = NSExpression(forConstantValue: backgroundLineWidth)
            
            // ---------------
            
            railwayStationLayer = MLNCircleStyleLayer(identifier: "railway_station", source: railwaysSource)
            railwayStationLayer.sourceLayerIdentifier = "railway_station"
            railwayStationLayer.circleColor = NSExpression(forConstantValue: UIColor(Color.stationRailway))
            //railwayStationLayer.circleRadius = NSExpression(forConstantValue: 1) https://docs.maptiler.com/maplibre-gl-native-ios/predicates-and-expressions/
            
            tramStopLayer = MLNCircleStyleLayer(identifier: "tram_stop", source: railwaysSource)
            tramStopLayer.sourceLayerIdentifier = "tram_stop"
            tramStopLayer.circleColor = NSExpression(forConstantValue: UIColor(Color.stationTram))
            
            subwayStationLayer = MLNCircleStyleLayer(identifier: "subway_station", source: railwaysSource)
            subwayStationLayer.sourceLayerIdentifier = "subway_station"
            subwayStationLayer.circleColor = NSExpression(forConstantValue: UIColor(Color.stationSubway))
            
            lightRailwayStationLayer = MLNCircleStyleLayer(identifier: "light_railway_station", source: railwaysSource)
            lightRailwayStationLayer.sourceLayerIdentifier = "light_railway_station"
            lightRailwayStationLayer.circleColor = NSExpression(forConstantValue: UIColor(Color.stationLightRailway))
            
            // ---------------
            
            railwayStationNameLayer = MLNSymbolStyleLayer(identifier: "railway_station_name", source: railwaysSource)
            railwayStationNameLayer.sourceLayerIdentifier = "railway_station_name"
            railwayStationNameLayer.text = NSExpression(forKeyPath: "name")
            railwayStationNameLayer.textHaloColor = NSExpression(forConstantValue: UIColor.white)
            railwayStationNameLayer.textHaloWidth = NSExpression(forConstantValue: 2)
            railwayStationNameLayer.textOffset = NSExpression(forConstantValue: CGVector.init(dx: 0, dy: 0.7))
            
            subwayStationNameLayer = MLNSymbolStyleLayer(identifier: "subway_station_name", source: railwaysSource)
            subwayStationNameLayer.sourceLayerIdentifier = "subway_station_name"
            subwayStationNameLayer.text = NSExpression(forKeyPath: "name")
            subwayStationNameLayer.textHaloColor = NSExpression(forConstantValue: UIColor.white)
            subwayStationNameLayer.textHaloWidth = NSExpression(forConstantValue: 2)
            subwayStationNameLayer.textOffset = NSExpression(forConstantValue: CGVector.init(dx: 0, dy: 0.7))
            
            lightRailwayStationNameLayer = MLNSymbolStyleLayer(identifier: "light_railway_station_name", source: railwaysSource)
            lightRailwayStationNameLayer.sourceLayerIdentifier = "light_railway_station_name"
            lightRailwayStationNameLayer.text = NSExpression(forKeyPath: "name")
            lightRailwayStationNameLayer.textHaloColor = NSExpression(forConstantValue: UIColor.white)
            lightRailwayStationNameLayer.textHaloWidth = NSExpression(forConstantValue: 2)
            lightRailwayStationNameLayer.textOffset = NSExpression(forConstantValue: CGVector.init(dx: 0, dy: 0.7))
            
            tramStopNameLayer = MLNSymbolStyleLayer(identifier: "tram_stop_name", source: railwaysSource)
            tramStopNameLayer.sourceLayerIdentifier = "tram_stop_name"
            tramStopNameLayer.text = NSExpression(forKeyPath: "name")
            tramStopNameLayer.textHaloColor = NSExpression(forConstantValue: UIColor.white)
            tramStopNameLayer.textHaloWidth = NSExpression(forConstantValue: 2)
            tramStopNameLayer.textOffset = NSExpression(forConstantValue: CGVector.init(dx: 0, dy: 0.7))
            
            super.init()
            
            self.mapSourceService.mapDelegate = self
        }
        
        // add sources and layers after loading default style, mapView.style is nil prior to this
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            print("mapView didFinishLoading")
            self.mapView = mapView
            
            mapView.style?.addSource(railwaysSource)
            
            
            updateLayers()
            
            mapView.style?.addLayer(osmRasterStyleLayer)
            
            // tracks
            
            mapView.style?.addLayer(tracksRailwayLayerBackground)
            mapView.style?.addLayer(tracksRailwayLayer)
            
            mapView.style?.addLayer(tracksNarrowGaugeLayerBackground)
            mapView.style?.addLayer(tracksNarrowGaugeLayer)
            
            mapView.style?.addLayer(tracksSubwayLayerBackground)
            mapView.style?.addLayer(tracksSubwayLayer)
            
            mapView.style?.addLayer(tracksTramwayLayerBackground)
            mapView.style?.addLayer(tracksTramwayLayer)
            
            mapView.style?.addLayer(tracksLightRailwayLayerBackground)
            mapView.style?.addLayer(tracksLightRailwayLayer)
            
            mapView.style?.addLayer(tracksDisusedLayerBackground)
            mapView.style?.addLayer(tracksDisusedLayer)
            
            // Stations/stops
            
            mapView.style?.addLayer(railwayStationLayer)
            mapView.style?.addLayer(tramStopLayer)
            mapView.style?.addLayer(subwayStationLayer)
            mapView.style?.addLayer(lightRailwayStationLayer)
            
            // Stations/stops names
            mapView.style?.addLayer(railwayStationNameLayer)
            mapView.style?.addLayer(tramStopNameLayer)
            mapView.style?.addLayer(subwayStationNameLayer)
            mapView.style?.addLayer(lightRailwayStationNameLayer)
            
#if DEBUG
            //dbStats()
#endif
        }
        
#if DEBUG
        func dbStats() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let features = self.railwaysSource.features(sourceLayerIdentifiers: ["railway_station", "tram_stop", "subway_station", "light_railway_station", "tram_stop_name", "subway_station_name", "light_railway_station_name", "railway_station_name"], predicate: nil)
                
                var railwayStationCount = 0, tramStopCount = 0, subwayStationCount = 0, lightRailwayStationCount = 0
                
                for feature in features {
                    if feature.isKind(of: MLNPointFeature.self) {
                        if let nodeType = feature.attribute(forKey: "nt") as? Int {
                            switch NodeType(rawValue: nodeType) {
                            case .tram: tramStopCount += 1
                            case .subway: subwayStationCount += 1
                            case .lightRail: lightRailwayStationCount += 1
                            default:
                                railwayStationCount += 1
                            }
                        }
                    }
                }
                
                print("Railway \(railwayStationCount)")
                print("Tram \(tramStopCount)")
                print("Subway \(subwayStationCount)")
                print("Light railway \(lightRailwayStationCount)")
            }
            
        }
#endif
        
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
                
                tracksRailwayLayerBackground.isVisible = viewModel.mapOptions.showRailways
                tracksRailwayLayer.isVisible = viewModel.mapOptions.showRailways
                
                tracksNarrowGaugeLayerBackground.isVisible = viewModel.mapOptions.showNarrowGauge
                tracksNarrowGaugeLayer.isVisible = viewModel.mapOptions.showNarrowGauge
                
                tracksSubwayLayerBackground.isVisible = viewModel.mapOptions.showSubways
                tracksSubwayLayer.isVisible = viewModel.mapOptions.showSubways
                
                tracksTramwayLayerBackground.isVisible = viewModel.mapOptions.showTramways
                tracksTramwayLayer.isVisible = viewModel.mapOptions.showTramways
                
                tracksLightRailwayLayerBackground.isVisible = viewModel.mapOptions.showLightRailways
                tracksLightRailwayLayer.isVisible = viewModel.mapOptions.showLightRailways
                
                tracksDisusedLayerBackground.isVisible = viewModel.mapOptions.showDisused
                tracksDisusedLayer.isVisible = viewModel.mapOptions.showDisused
                
                // stations/stops
                
                railwayStationLayer.isVisible = viewModel.mapOptions.showRailwayStations
                railwayStationNameLayer.isVisible = viewModel.mapOptions.showRailwayStations
                
                tramStopLayer.isVisible = viewModel.mapOptions.showTramStops
                tramStopNameLayer.isVisible = viewModel.mapOptions.showTramStops
                
                subwayStationLayer.isVisible = viewModel.mapOptions.showSubwayStations
                subwayStationNameLayer.isVisible = viewModel.mapOptions.showSubwayStations
                
                lightRailwayStationLayer.isVisible = viewModel.mapOptions.showLightRailwayStations
                lightRailwayStationNameLayer.isVisible = viewModel.mapOptions.showLightRailwayStations
            }
        }
        
        func getAreaFeatures() -> [MLNFeature] {
            if let frame = mapView?.frame {
                return mapView?.visibleFeatures(in: frame) ?? []
            } else {
                return []
            }
        }
        
        func flyToCoordinate(coordinate: CLLocationCoordinate2D) {
            mapView?.fly(to: MLNMapCamera(lookingAtCenter: coordinate, altitude: 25_000, pitch: 0, heading: 0))
        }
        
        func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {
            print("mapView didUpdate")
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
