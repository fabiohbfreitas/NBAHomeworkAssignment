//
//  ContentView.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var teamsViewModel: TeamsViewModel = .init(teamsService: TeamsService())
    
    var body: some View {
        NavigationView {
            TeamsListView(teamsViewModel: teamsViewModel)
        }
    }
}

#Preview {
    HomeView()
}
