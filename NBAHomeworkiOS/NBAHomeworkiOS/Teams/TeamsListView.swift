//
//  TeamsView.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI
import Combine

struct TeamsListView: View {
    @ObservedObject var teamsViewModel: TeamsViewModel
    
    var body: some View {
        
        VStack {
            switch teamsViewModel.teams {
            case .loading, .idle:
                progress
            case .data(let teams):
                teamsView(teams)
            case .error(let error):
                errorView(error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(teamsViewModel.filter.rawValue) {
                    teamsViewModel.changeFilter()
                }
            }
        }
        .refreshable {
            fetchTeams()
        }
        .task {
            await teamsViewModel.fetchTeams()
        }
        .navigationTitle("Home")
    }
}

private extension TeamsListView {
    
    private func fetchTeams() {
        Task {
            await teamsViewModel.fetchTeams()
        }
    }
    
    private var progress: some View {
        VStack {
            ProgressView()
        }
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        VStack {
            Text("Error while fetching teams")
                .font(.callout)
                .bold()
                .foregroundStyle(.red)
            Button("Try again") {
                fetchTeams()
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.red).opacity(0.1))
    }
    
    
    @ViewBuilder
    private func teamsView(_ teams: [Team]) -> some View {
        List(teams) { team in
            teamRow(team)
        }
    }
    
    @ViewBuilder
    private func teamRow(_ team: Team) -> some View {
        VStack(alignment: .leading) {
            Text(team.fullName)
                .font(.headline)
                .foregroundColor(.primary)
            HStack(alignment: .firstTextBaseline) {
                Text("\(team.city)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(team.conference)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
        }
    }
}

#Preview {
    NavigationView {
        TeamsListView(teamsViewModel: TeamsViewModel(teamsService: TeamsService()))
    }
}
