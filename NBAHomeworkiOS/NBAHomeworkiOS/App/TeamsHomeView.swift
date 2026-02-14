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

struct TeamsHomeView: View {
    private let tabs: [HomeTab]
    
    init(tabs: [HomeTab]) {
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
    
    static func makeHomeView() -> some View {
        let service: TeamsService = TeamsServiceFactory.makeTeamService()

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
        
        return TeamsHomeView(tabs: tabs)
    }
}

#Preview {
    TeamsHomeView.makeHomeView()
}
