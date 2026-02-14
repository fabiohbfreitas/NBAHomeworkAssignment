//
//  TeamsServiceInMemory.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

class TeamsServiceInMemory: TeamsService {
    static let sampleTeam = Team(id: 1, fullName: "Los Angeles Lakers", city: "Los Angeles", conference: "West")
    
    private let mockTeams: [Team] = [
        Team(id: 1, fullName: "Los Angeles Lakers", city: "Los Angeles", conference: "West"),
        Team(id: 2, fullName: "Boston Celtics", city: "Boston", conference: "East"),
        Team(id: 3, fullName: "Golden State Warriors", city: "San Francisco", conference: "West")
    ]
    
    private let mockPlayers: [Player] = [
        Player(id: 101, firstName: "LeBron", lastName: "James", team: Team(id: 1, fullName: "Los Angeles Lakers", city: "Los Angeles", conference: "West")),
        Player(id: 102, firstName: "Jayson", lastName: "Tatum", team: Team(id: 2, fullName: "Boston Celtics", city: "Boston", conference: "East")),
        Player(id: 103, firstName: "Stephen", lastName: "Curry", team: Team(id: 3, fullName: "Golden State Warriors", city: "San Francisco", conference: "West"))
    ]
    
    private let mockGames: [TeamGame] = (1...12).map { i in
        TeamGame(
            id: i,
            homeTeam: i % 2 == 0 ? "Los Angeles Lakers" : "Boston Celtics",
            homeScore: "\(100 + i)",
            visitorTeam: i % 2 == 0 ? "Golden State Warriors" : "Los Angeles Lakers",
            visitorScore: "\(98 + i)"
        )
    }
    
    private static let SLEEP_NS: UInt64 = 300_000_000

    func listTeams() async throws -> [Team] {
        try? await Task.sleep(nanoseconds: Self.SLEEP_NS)
        return mockTeams
    }

    func listGames(forTeam teamId: Int, cursor: Int?) async throws -> ([TeamGame], Int?) {
        try? await Task.sleep(nanoseconds: Self.SLEEP_NS)
        
        guard let team = mockTeams.first(where: { $0.id == teamId }) else {
            return ([], nil)
        }
        
        let filteredGames = mockGames.filter {
            $0.homeTeam == team.fullName || $0.visitorTeam == team.fullName
        }
        
        let pageSize = 4
        let startIndex = cursor ?? 0
        
        if startIndex >= filteredGames.count {
            return ([], nil)
        }
        
        let endIndex = min(startIndex + pageSize, filteredGames.count)
        let pagedGames = Array(filteredGames[startIndex..<endIndex])
        let nextCursor = endIndex < filteredGames.count ? endIndex : nil
        
        return (pagedGames, nextCursor)
    }

    func searchPlayers(query: String) async throws -> [Player] {
        if query.isEmpty { return [] }
        return mockPlayers.filter {
            $0.firstName.localizedCaseInsensitiveContains(query) ||
            $0.lastName.localizedCaseInsensitiveContains(query)
        }
    }
}
