//
//  TeamPlayerSearch.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

struct TeamPlayerView: View {
    @ObservedObject var teamPlayerViewModel: TeamPlayerViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                switch teamPlayerViewModel.searchResults {
                case .idle:
                    EmptyView()
                case .loading:
                    SimpleLoading()
                case .data(let results):
                    playersView(results)
                case .error:
                    ErrorWithRetry(
                        title: "Failed to perform search for \(teamPlayerViewModel.query)",
                        tryAgainAction: {
                            teamPlayerViewModel.searchPlayers()
                        }
                    )
                }
            }
            .navigationTitle("Player")
            .searchable(text: $teamPlayerViewModel.query, prompt: "Search")
        }
    }
    
    @ViewBuilder
    private func playersView(_ players: [Player]) -> some View {
        if players.isEmpty {
            Text("Type a player's name to search")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else {
            List(players) { player in
                NavigationLink {
                    makeDestination(forTeam: player.team)
                } label: {
                    playerRow(player)
                }
                
            }
        }
    }
    
    @ViewBuilder
    private func makeDestination(forTeam team: Team) -> some View {
        TeamDetailsListView(selectedTeam: team, teamsViewModel: TeamDetailsViewModel(teamsService: TeamsServiceFactory.makeTeamService()))
    }
    
    @ViewBuilder
    private func playerRow(_ player: Player) -> some View {
        VStack(alignment: .leading) {
            Text(personName(player), format: .name(style: .long))
                .font(.headline)
                .foregroundStyle(.primary)
            Text(player.team.fullName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func personName(_ player: Player) -> PersonNameComponents {
        return PersonNameComponents(givenName: player.firstName, familyName: player.lastName)
    }
}

#Preview {
    NavigationView {
        TeamPlayerView(teamPlayerViewModel: TeamPlayerViewModel(teamsService: TeamsServiceInMemory()))
    }
}

