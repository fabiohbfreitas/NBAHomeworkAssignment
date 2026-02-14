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
    private var cursor: Int? = nil
    @Published var isPaginating: Bool = false
    private var hasNext: Bool = false
    
    func fetchInitialGames(forId id: Int) async {
        do {
            isPaginating = false
            teams = .loading
            let (listedGames, hasNextPage, next_cursor) = try await teamsService.listGames(forTeam: id)
            teams = .data(listedGames)
            hasNext = hasNextPage
            cursor = next_cursor
        } catch {
            teams = .error(error)
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func fetchNextGames(forId id: Int) async {
        guard !isPaginating, hasNext, let next = cursor else { return }
        isPaginating = true
        do {
            let (listedGames, hasNextPage, next_cursor) = try await teamsService.listGames(forTeam: id, cursor: next)
            switch teams {
            case .data(let current):
                let combined = current + listedGames
                teams = .data(combined)
            case .idle, .loading, .error:
                teams = .data(listedGames)
            }
            hasNext = hasNextPage
            cursor = next_cursor
            isPaginating = false
        } catch {
            isPaginating = false
            print("ERROR (pagination): \(error.localizedDescription)")
        }
    }
}

