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
    
    func updateUIView(_ mapView: MLNMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate {
        var viewModel: MapTabViewModel
        
        init(viewModel: MapTabViewModel) {
            self.viewModel = viewModel
        }
        
        // add sources and layers after loading default style, mapView.style is nil prior to this
        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            
            let mbURL = "mbtiles:///\(Bundle.main.url(forResource: "poland", withExtension: "mbtiles")!.path())"
            let railwaysSource = MLNVectorTileSource(identifier: "railway", tileURLTemplates: [mbURL], options: [
                .minimumZoomLevel: 4,
                .maximumZoomLevel: 12,
                .attributionInfos: [
                    MLNAttributionInfo(title: NSAttributedString(string: "© MapLibre"), url: URL(string: "https://maplibre.org"))
                ]
            ])
            mapView.style?.addSource(railwaysSource)
            
            // add layer representing railway tracks
            let tracksLayer = MLNLineStyleLayer(identifier: "railway", source: railwaysSource)
            tracksLayer.sourceLayerIdentifier = "railway"
            tracksLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            tracksLayer.lineWidth = NSExpression(forConstantValue: 2)
            mapView.style?.addLayer(tracksLayer)
            
            let tracksNarrowGaugeLayer = MLNLineStyleLayer(identifier: "narrow_gauge", source: railwaysSource)
            tracksNarrowGaugeLayer.sourceLayerIdentifier = "narrow_gauge"
            tracksNarrowGaugeLayer.lineColor = NSExpression(forConstantValue: UIColor.green)
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
            self.viewModel.onMapTap(debugString: String(describing: features))
        }
    }
}
