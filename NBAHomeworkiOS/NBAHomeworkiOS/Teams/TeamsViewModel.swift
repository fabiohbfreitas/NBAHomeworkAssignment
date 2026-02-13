//
//  TeamsViewModel.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI
import Combine

final class TeamsViewModel: ObservableObject {
    enum Resource<T> {
        case idle
        case loading
        case data(T)
        case error(Error)
    }
    
    let teamsService: TeamsService
    
    init(teamsService: TeamsService) {
        self.teamsService = teamsService
    }
    
    @Published var teams: Resource<[Team]> = .idle
    
    func fetchTeams() async {
        do {
            teams = .loading
            let listedTeams = try await teamsService.listTeams()
            teams = .data(listedTeams)
        } catch {
            teams = .error(error)
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
