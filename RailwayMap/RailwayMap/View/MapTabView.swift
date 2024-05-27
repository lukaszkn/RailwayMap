//
//  MapTabView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import SwiftUI
import PermissionsSwiftUILocation
import CoreLocation

struct MapTabView: View {
    @State var viewModel = MapTabViewModel()
    @State private var showingAskPermissionsModal = false
    
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
        .JMModal(showModal: $showingAskPermissionsModal, for: [.location],
                 autoDismiss: true,
                 autoCheckAuthorization: true,
                 onDisappear: {
                 }
        )
        .setPermissionComponent(for: .location,
                                image: AnyView(Image(systemName: "location.fill.viewfinder")),
                                title: String(localized: "Location"),
                                description: String(localized: "Allow to access your location to see which stations/stops you're closed to"))
        .onAppear() {
            if CLLocationManager().authorizationStatus == .notDetermined {
                showingAskPermissionsModal = true
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
