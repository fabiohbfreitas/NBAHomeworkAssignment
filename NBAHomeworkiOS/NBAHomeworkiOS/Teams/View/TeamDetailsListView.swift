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
                        title: "Error while fetching details for \(selectedTeam.fullName)",
                        tryAgainAction: {
                            fetchInitialGames()
                        }
                    )
                }
            }
            .refreshable {
                fetchInitialGames()
            }
            .task {
                await teamsViewModel.fetchInitialGames(forId: selectedTeam.id)
            }
            .navigationTitle(selectedTeam.fullName)
        }
    }
}

private extension TeamDetailsListView {
    
    private func fetchInitialGames() {
        Task {
            await teamsViewModel.fetchInitialGames(forId: selectedTeam.id)
        }
    }
    
    private func fetchNextGames() {
        Task {
            await teamsViewModel.fetchNextGames(forId: selectedTeam.id)
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
                fetchInitialGames()
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
        List {
            ForEach(teams) { team in
                gameRow(team)
                    .onAppear {
                        if team.id == teams.last?.id {
                            fetchNextGames()
                        }
                    }
            }
            if teamsViewModel.isPaginating {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
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
        TeamDetailsListView(selectedTeam: TeamsServiceInMemory.sampleTeam ,teamsViewModel: TeamDetailsViewModel(teamsService: TeamsServiceInMemory()))
    }
}

