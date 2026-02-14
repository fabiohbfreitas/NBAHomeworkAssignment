//
//  TeamPlayerViewModel.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI
import Combine

final class TeamPlayerViewModel: ObservableObject {
    let teamsService: TeamsService
    
    @Published var query: String = ""
    @Published var searchResults: Resource<[Player]> = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    init(teamsService: TeamsService) {
        self.teamsService = teamsService
        setupSearch()
    }
    
    func setupSearch() {
        $query
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchPlayers()
            }
            .store(in: &cancellables)
    }
    
    func searchPlayers() {
        guard !query.isEmpty else {
            searchResults = .data([])
            return
        }
        Task {
            do {
                searchResults = .loading
                let players = try await teamsService.searchPlayers(query: query)
                searchResults = .data(players)
            } catch {
                searchResults = .error(error)
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
    }
}
