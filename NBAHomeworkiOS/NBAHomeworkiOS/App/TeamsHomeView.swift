//
//  ContentView.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

struct HomeTab: Identifiable {
    let name: String
    let icon: String
    let view: AnyView
    
    var id: String { name }
}

let service = TeamsServiceInMemory()

let tabs: [HomeTab] = [
    HomeTab(
        name: "Home",
        icon: "house.fill",
        view: AnyView(
                TeamsListView(teamsViewModel: TeamsViewModel(teamsService: service))
        )
    ),
    HomeTab(
        name: "Players",
        icon: "person.fill",
        view: AnyView(
            TeamPlayerView(teamPlayerViewModel: TeamPlayerViewModel(teamsService: service))
        )
    )
]

struct TeamsHomeView: View {
    private let teamsService: TeamsService
    private let tabs: [HomeTab]
    
    init(teamsService: TeamsService, tabs: [HomeTab]) {
        self.teamsService = teamsService
        self.tabs = tabs
    }
    
    var body: some View {
        TabView {
            ForEach(tabs) { tab in
                tab.view
                    .tabItem {
                        Label(tab.name, systemImage: tab.icon)
                    }
            }
        }
    }
}

#Preview {
    TeamsHomeView(teamsService: TeamsServiceInMemory(), tabs: tabs)
}
