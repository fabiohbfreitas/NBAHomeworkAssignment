//
//  TeamsViewModel.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI
import Combine

final class TeamsViewModel: ObservableObject {
    let teamsService: TeamsService
    
    init(teamsService: TeamsService) {
        self.teamsService = teamsService
    }
    
    @Published var teams: Resource<[Team]> = .idle
    @Published var isFilterSheetActive = false
    @Published var filter: SortingFilter = .name
    
    func fetchTeams() async {
        do {
            teams = .loading
            let listedTeams = try await teamsService.listTeams()
            let sortedTeams = teamsSorted(listedTeams, by: filter)
            teams = .data(sortedTeams)
        } catch {
            teams = .error(error)
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func applyFilters() {
        guard case .data(let previousTeams) = teams else {
            return
        }
        let orderedTeams = teamsSorted(previousTeams, by: filter)
        withAnimation {
            teams = .data(orderedTeams)
        }
    }
    
    private func teamsSorted(_ teams: [Team], by filter: SortingFilter) -> [Team] {
        switch filter {
        case .name:
            return teams.sorted(by: { $0.fullName < $1.fullName })
        case .city:
            return teams.sorted(by: { $0.city < $1.city })
        case .conference:
            return teams.sorted(by: { $0.conference < $1.conference })
        }
    }
}

enum SortingFilter: String, CaseIterable {
    case name = "Name"
    case city = "City"
    case conference = "Conference"
}

enum Resource<T> {
    case idle
    case loading
    case data(T)
    case error(Error)
}
