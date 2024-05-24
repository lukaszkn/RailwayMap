//
//  MapLayerOptionCellView.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import SwiftUI

struct MapLayerOptionCellView: View {
    var description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Toggle(description, isOn: $isOn)
        }
    }
}

#Preview {
    MapLayerOptionCellView(description: "Show Open Street Map", isOn: Binding.constant(true))
}
