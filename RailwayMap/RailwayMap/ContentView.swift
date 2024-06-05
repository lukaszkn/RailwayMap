//
//  ContentView.swift
//  RailwayMap
//
//  Created by Lukasz on 20/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = MainContentViewModel()
    
    enum TabIndex: Int {
        case map = 0
        case explore = 1
    }
    
    var tabIndexHandler: Binding<Int> { Binding(
        get: { self.viewModel.tabSelection },
        set: { self.viewModel.setSelectedTab(tabIndex: $0) }
    )}
    
    var body: some View {
        TabView(selection: tabIndexHandler) {
            MapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabIndex.map.rawValue)
            
            ExploreTabView()
                .tabItem {
                    Label("Explore", systemImage: "scope")
                        .accessibilityIdentifier("explore_tab")
                }
                .tag(TabIndex.explore.rawValue)
        }
    }
}

#Preview {
    ContentView()
}
