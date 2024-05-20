//
//  MapTabView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import SwiftUI

struct MapTabView: View {
    var body: some View {
        MapLibreView()
            .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    MapTabView()
}
