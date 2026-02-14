//
//  ContentView.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

struct HomeView: View {
    
    private static let teamsService = TeamsService()
    
    @StateObject private var teamsViewModel: TeamsViewModel = .init(teamsService: teamsService)
    @StateObject private var teamPlayerViewModel: TeamPlayerViewModel = .init(teamsService: teamsService)
    
    var body: some View {
        TabView {
            TeamsListView(teamsViewModel: teamsViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            TeamPlayerView(teamPlayerViewModel: teamPlayerViewModel)
                .tabItem {
                    Label("Players", systemImage: "person.fill")
                }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
