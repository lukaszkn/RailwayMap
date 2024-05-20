//
//  ContentView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import SwiftUI

struct ContentView: View {
    enum TabIndex: Int {
        case map = 0
    }
    
    var body: some View {
        TabView {
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabIndex.map.rawValue)
        }
    }
}

#Preview {
    ContentView()
}
