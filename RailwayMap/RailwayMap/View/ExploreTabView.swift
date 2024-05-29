//
//  ExploreTabView.swift
//  RailwayMap
//
//  Created by Lukasz on 25/05/2024.
//

import SwiftUI

struct ExploreTabView: View {
    @State var viewModel = ExploreTabViewModel()
    
    var body: some View {
        NavigationStack {
            MapAreaDetailsView(features: $viewModel.areaFeatures)
                .navigationTitle("Explore nearby area")
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ExploreTabView()
}
