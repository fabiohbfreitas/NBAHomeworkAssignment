//
//  TeamDetailsViewModel.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//


import SwiftUI
import Combine

final class TeamDetailsViewModel: ObservableObject {
    let teamsService: TeamsService
    
    init(teamsService: TeamsService) {
        self.teamsService = teamsService
    }
    
    @Published var teams: Resource<[TeamGame]> = .idle
    
    func fetchTeamGames(forId id: Int) async {
        do {
            teams = .loading
            let listedGames = try await teamsService.listGames(forTeam: id)
            teams = .data(listedGames)
        } catch {
            teams = .error(error)
            print("ERROR: \(error.localizedDescription)")
        }
    }
}