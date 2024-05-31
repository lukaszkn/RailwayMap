//
//  MapLayersOptions.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import SwiftUI

struct MapLayersOptionsView: View {
    @Binding var options: MapLayerOptions
    
    var body: some View {
        NavigationStack {
            List {
                Section("Background layer") {
                    MapLayerOptionCellView(description: String(localized: "Open Street Map"), isOn: $options.showOpenStreetMap)
                }
                
                Section("Tracks") {
                    MapLayerOptionCellView(lineColor: Color.tracksRailways,
                                           description: String(localized: "Railways"), isOn: $options.showRailways)
                    MapLayerOptionCellView(lineColor: Color.tracksLightRailways,
                                           description: String(localized: "Light railways"), isOn: $options.showLightRailways)
                    MapLayerOptionCellView(lineColor: Color.tracksNarrowGauge,
                                           description: String(localized: "Narrow gauge"), isOn: $options.showNarrowGauge)
                    MapLayerOptionCellView(lineColor: Color.tracksSubways,
                                           description: String(localized: "Subways"), isOn: $options.showSubways)
                    MapLayerOptionCellView(lineColor: Color.tracksTramways,
                                           description: String(localized: "Tramways"), isOn: $options.showTramways)
                    MapLayerOptionCellView(lineColor: Color.tracksDisused,
                                           description: String(localized: "Disused"), isOn: $options.showDisused)
                }
                
                Section("Stations") {
                    MapLayerOptionCellView(isCircle: true, lineColor: Color.stationRailway, description: String(localized: "Railway"), isOn: $options.showRailwayStations)
                    MapLayerOptionCellView(isCircle: true, lineColor: Color.stationLightRailway, description: String(localized: "Light railway"), isOn: $options.showLightRailwayStations)
                    MapLayerOptionCellView(isCircle: true, lineColor: Color.stationSubway, description: String(localized: "Subway"), isOn: $options.showSubwayStations)
                    MapLayerOptionCellView(isCircle: true, lineColor: Color.stationTram, description: String(localized: "Tram"), isOn: $options.showTramStops)
                }
            }
            .navigationTitle("Map options")
        }
    }
}

#Preview {
    @State var options = MapLayerOptions()
    return MapLayersOptionsView(options: $options)
}
