//
//  MapLayerOptionCellView.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import SwiftUI

struct MapLayerOptionCellView: View {
    var lineColor: Color?
    var description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            if let color = lineColor {
                Rectangle()
                    .frame(width: 20, height: 3)
                    .foregroundStyle(color)
                    .padding(.trailing, 6)
            }
            
            Toggle(description, isOn: $isOn)
        }
    }
}

#Preview {
    MapLayerOptionCellView(description: "Show Open Street Map", isOn: Binding.constant(true))
}
