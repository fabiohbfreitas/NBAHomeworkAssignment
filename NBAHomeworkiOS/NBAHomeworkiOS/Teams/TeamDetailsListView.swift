//
//  TeamDetailsList.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

struct TeamDetailsListView: View {
    let selectedTeam: Team
    
    @ObservedObject var teamsViewModel: TeamDetailsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                switch teamsViewModel.teams {
                case .idle:
                    EmptyView()
                case .loading:
                    SimpleLoading()
                case .data(let teams):
                    teamGamesView(teams)
                case .error:
                    ErrorWithRetry(
                        title: "Error when fetching details for \(selectedTeam.fullName)",
                        tryAgainAction: {
                            fetchTeamGames()
                        }
                    )
                }
            }
            .refreshable {
                fetchTeamGames()
            }
            .task {
                await teamsViewModel.fetchTeamGames(forId: selectedTeam.id)
            }
            .navigationTitle(selectedTeam.fullName)
        }
    }
}

private extension TeamDetailsListView {
    
    private func fetchTeamGames() {
        Task {
            await teamsViewModel.fetchTeamGames(forId: selectedTeam.id)
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
                fetchTeamGames()
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.red).opacity(0.1))
    }
    
    
    @ViewBuilder
    private func teamGamesView(_ teams: [TeamGame]) -> some View {
        List(teams) { team in
            gameRow(team)
        }
    }
    
    @ViewBuilder
    private func gameRow(_ team: TeamGame) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Home Team")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(team.homeTeam)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(team.homeScore)
                    .monospacedDigit()
                    .font(.title)
                    .fontWeight(team.homeScore > team.visitorScore ? .semibold : .regular)
                    .foregroundStyle(team.homeScore > team.visitorScore ? .green : .secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Visitor Team")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(team.visitorTeam)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(team.visitorScore)
                    .monospacedDigit()
                    .font(.title)
                    .fontWeight(team.homeScore < team.visitorScore ? .semibold : .regular)
                    .foregroundStyle(team.homeScore < team.visitorScore ? .green : .secondary)
            }
        }
    }
}

#Preview {
    NavigationView {
        TeamDetailsListView(selectedTeam: Team(id: 6, fullName: "Cleveleand Cavaliers", city: "City", conference: "Conference") ,teamsViewModel: TeamDetailsViewModel(teamsService: TeamsService()))
    }
}
