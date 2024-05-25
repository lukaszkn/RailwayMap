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
                    MapLayerOptionCellView(description: String(localized: "Railways"), isOn: $options.showRailways)
                    MapLayerOptionCellView(description: String(localized: "Light railways"), isOn: $options.showLightRailways)
                    MapLayerOptionCellView(description: String(localized: "Narrow gauge"), isOn: $options.showNarrowGauge)
                    MapLayerOptionCellView(description: String(localized: "Subways"), isOn: $options.showSubways)
                    MapLayerOptionCellView(description: String(localized: "Tramways"), isOn: $options.showTramways)
                    MapLayerOptionCellView(description: String(localized: "Disused"), isOn: $options.showDisused)
                }
                
                Section("Stations") {
                    MapLayerOptionCellView(description: String(localized: "Railway"), isOn: $options.showRailwayStations)
                    MapLayerOptionCellView(description: String(localized: "Light railway"), isOn: $options.showLightRailwayStations)
                    MapLayerOptionCellView(description: String(localized: "Subway"), isOn: $options.showSubwayStations)
                    MapLayerOptionCellView(description: String(localized: "Tram"), isOn: $options.showTramStops)
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
