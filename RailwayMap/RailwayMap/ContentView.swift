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
        case explore = 1
    }
    
    var body: some View {
        TabView {
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabIndex.map.rawValue)
            
            ExploreTabView()
                .tabItem {
                    Label("Explore", systemImage: "scope")
                }
                .tag(TabIndex.explore.rawValue)
        }
    }
}

#Preview {
    ContentView()
}
