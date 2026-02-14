//
//  TeamsView.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

struct TeamsListView: View {
    @ObservedObject var teamsViewModel: TeamsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                switch teamsViewModel.teams {
                case .loading, .idle:
                    SimpleLoading()
                case .data(let teams):
                    teamsView(teams)
                case .error:
                    ErrorWithRetry(title: "Error while fetching teams", tryAgainAction: fetchTeams)
                }
            }
            .sheet(isPresented: $teamsViewModel.isFilterSheetActive) {
                TeamFilterSheet(teamsViewModel: teamsViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(teamsViewModel.filter.rawValue) {
                        teamsViewModel.isFilterSheetActive = true
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
}

private extension TeamsListView {
    private func fetchTeams() {
        Task {
            await teamsViewModel.fetchTeams()
        }
    }
    
    @ViewBuilder
    private func teamsView(_ teams: [Team]) -> some View {
        List(teams) { team in
            NavigationLink {
                TeamDetailsListView(selectedTeam: team, teamsViewModel: TeamDetailsViewModel(teamsService: TeamsServiceLive()))
            } label: {
                teamRow(team)
            }
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
        TeamsListView(teamsViewModel: TeamsViewModel(teamsService: TeamsServiceInMemory()))
    }
}
