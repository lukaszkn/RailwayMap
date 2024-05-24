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
                    MapLayerOptionCellView(description: "Show Open Street Map", isOn: $options.showOpenStreetMap)
                }
                
                Section("Tracks") {
                    MapLayerOptionCellView(description: "Show railways", isOn: $options.showRailways)
                    MapLayerOptionCellView(description: "Show light railways", isOn: $options.showLightRailways)
                    MapLayerOptionCellView(description: "Show narrow gauge", isOn: $options.showNarrowGauge)
                    MapLayerOptionCellView(description: "Show subways", isOn: $options.showSubways)
                    MapLayerOptionCellView(description: "Show tramways", isOn: $options.showTramways)
                    MapLayerOptionCellView(description: "Show disused", isOn: $options.showDisused)
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
