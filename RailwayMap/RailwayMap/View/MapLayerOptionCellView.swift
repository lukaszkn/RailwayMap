//
//  MapLayerOptionCellView.swift
//  RailwayMap
//
//  Created by Lukasz on 24/05/2024.
//

import SwiftUI

struct MapLayerOptionCellView: View {
    var isCircle: Bool = false
    var lineColor: Color?
    var description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            if let color = lineColor {
                if isCircle {
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 20, height: 10)
                        .padding(.trailing, 6)
                } else {
                    Rectangle()
                        .frame(width: 20, height: 3)
                        .foregroundStyle(color)
                        .padding(.trailing, 6)
                }
            }
            
            Toggle(description, isOn: $isOn)
        }
    }
}

#Preview {
    VStack {
        MapLayerOptionCellView(isCircle: true, lineColor: Color.red, description: "Show Open Street Map", isOn: Binding.constant(true))
        MapLayerOptionCellView(lineColor: Color.red, description: "Show Open Street Map", isOn: Binding.constant(true))
    }
}
