//
//  MapAreaDetailsView.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import SwiftUI
import MapLibre

struct MapAreaDetailsView: View {
    var features: [MLNFeature]
    
    @State private var viewModel = MapAreaDetailsViewModel()
    
    var body: some View {
        List {
            Section("Stations/stops") {
                ForEach(viewModel.stations) { station in
                    Text(station.name)
                }
            }
            
            Section("Tracks") {
                ForEach(viewModel.tracks) { track in
                    Text(track.name)
                }
            }
        }
        .onAppear() {
            viewModel.prepareData(features: features)
        }
    }
}

#Preview {
    let przeworsk = MLNPointFeature()
    przeworsk.attributes = ["name": "Przeworsk", "nt": 0]
    
    let kolejPrzeworska = MLNMultiPolylineFeature()
    kolejPrzeworska.attributes = ["name": "Kolej wąskotorowa Przeworsk-Dynów", "rt": 4, "wikipedia": "pl:Przeworska Kolej Dojazdowa"]
    
    let kolej91 = MLNMultiPolylineFeature()
    kolej91.attributes = ["name": "Linia kolejowa nr 988 Przeworsk - Przeworsk Towarowy", "network": "PKP", "rt": 0]
    
    return MapAreaDetailsView(features: [przeworsk, kolejPrzeworska, kolej91])
}
