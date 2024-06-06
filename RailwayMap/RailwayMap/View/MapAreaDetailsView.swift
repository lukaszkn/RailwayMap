//
//  MapAreaDetailsView.swift
//  RailwayMap
//
//  Created by Lukasz on 27/05/2024.
//

import SwiftUI
import MapLibre

struct MapAreaDetailsView: View {
    @Binding var features: [MLNFeature]
    
    @State private var viewModel = MapAreaDetailsViewModel()
    
    var body: some View {
        List {
            if !viewModel.stations.isEmpty {
                Section("Stations/stops (\(viewModel.stations.count))") {
                    ForEach(viewModel.stations) { station in
                        HStack {
                            Circle()
                                .foregroundColor(station.nodeType.typeColour())
                                .frame(width: 20, height: 10)
                                .padding(.trailing, 6)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(station.name)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                
                                Text(station.secondaryDescriptionLine)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Text(station.distanceString(location: viewModel.locationService.lastLocation))
                                .foregroundColor(.blue)
                                .font(.body)
                        }
                        .onTapGesture {
                            NotificationCenter.default.post(name: .mainTabIndexChangeRequest, object: ContentView.TabIndex.map.rawValue)
                            viewModel.mapSourceService.mapDelegate?.flyToCoordinate(coordinate: station.coordinate)
                        }
                    }
                }
            }
            
            if !viewModel.tracks.isEmpty {
                Section("Tracks (\(viewModel.tracks.count))") {
                    ForEach(viewModel.tracks) { track in
                        HStack {
                            Rectangle()
                                .frame(width: 20, height: 3)
                                .foregroundStyle(track.routeType.typeColour())
                                .padding(.trailing, 6)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(track.name)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                
                                Text(track.secondaryDescriptionLine)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        
                        if let wiki = track.wikipedia, let wikiUrl = track.wikiUrl {
                            Link(destination: wikiUrl, label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Wikipedia")
                                        .foregroundColor(.primary)
                                        .font(.headline)
                                    
                                    Text(wiki)
                                        .foregroundColor(.blue)
                                        .font(.subheadline)
                                }
                                .padding(.leading, 35)
                            })
                        }
                    }
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
    przeworsk.attributes = ["sid": 2, "name": "Przeworsk", "nt": 0]
    
    let kolejPrzeworska = MLNMultiPolylineFeature()
    kolejPrzeworska.attributes = ["name": "Kolej wąskotorowa Przeworsk-Dynów", "rt": 4, "wikipedia": "pl:Przeworska Kolej Dojazdowa"]
    
    let kolej91 = MLNMultiPolylineFeature()
    kolej91.attributes = ["name": "Linia kolejowa nr 988 Przeworsk - Przeworsk Towarowy", "network": "PKP", "rt": 0]
    
    let actonTown = MLNPointFeature()
    actonTown.coordinate = CLLocationCoordinate2DMake(51.5027051, -0.2799643)
    actonTown.attributes = ["sid": 1, "name": "Acton Town", "nt": 1, "line": "District;Piccadilly"]
    
    let imielin = MLNPointFeature() // https://www.openstreetmap.org/node/3390290598
    imielin.coordinate = CLLocationCoordinate2DMake(52.1493000, 21.0461062)
    imielin.attributes = ["sid": 3390290598, "name": "Imielin", "nt": 1, "colour": "blue"]
    
    let features: [MLNFeature] = [przeworsk, kolejPrzeworska, kolej91, actonTown, imielin]
    
    let binding = Binding {
        return features
    } set: { _ in
    }
    
    return MapAreaDetailsView(features: binding)
}
