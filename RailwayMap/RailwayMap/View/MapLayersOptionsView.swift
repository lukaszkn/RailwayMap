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
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Blue.Denim,
                                           description: String(localized: "Railways"), isOn: $options.showRailways)
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Green.MountainMeadow,
                                           description: String(localized: "Light railways"), isOn: $options.showLightRailways)
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Blue.PictonBlue,
                                           description: String(localized: "Narrow gauge"), isOn: $options.showNarrowGauge)
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Red.Cinnabar,
                                           description: String(localized: "Subways"), isOn: $options.showSubways)
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Violet.BlueGem,
                                           description: String(localized: "Tramways"), isOn: $options.showTramways)
                    MapLayerOptionCellView(lineColor: Color.FlatColor.Yellow.Turbo,
                                           description: String(localized: "Disused"), isOn: $options.showDisused)
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
