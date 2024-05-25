//
//  MapTabView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import SwiftUI

struct MapTabView: View {
    @State var viewModel = MapTabViewModel()
    
    var body: some View {
        ZStack {
            MapLibreView(viewModel: viewModel)
                .ignoresSafeArea(.container, edges: .top)
                .sheet(isPresented: $viewModel.showingMapTapSheet, content: {
                    ScrollView {
                        Text(viewModel.tapDebugString)
                    }
                })
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.showingMapOptions = true
                    } label: {
                        Image(systemName: "square.2.layers.3d")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .foregroundColor(.blue)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(6)
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showingMapOptions, onDismiss: {
            viewModel.mapDelegate?.updateLayers()
        }, content: {
            MapLayersOptionsView(options: $viewModel.mapOptions)
        })
    }
}

#Preview {
    MapTabView()
}
