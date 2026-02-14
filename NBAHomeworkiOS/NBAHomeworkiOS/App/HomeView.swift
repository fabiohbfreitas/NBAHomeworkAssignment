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
    @StateObject private var teamGamesViewModel: TeamDetailsViewModel = .init(teamsService: teamsService)
    
    var body: some View {
        NavigationView {
            TeamsListView(teamsViewModel: teamsViewModel)
//            TeamDetailsListView(selectedTeam: Team(id: 6, fullName: "Cleveland Caveliers", city: "City", conference: "Conference"), teamsViewModel: teamGamesViewModel)
        }
    }
}

#Preview {
    HomeView()
}
