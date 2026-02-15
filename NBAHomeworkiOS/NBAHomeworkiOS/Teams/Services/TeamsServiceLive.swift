//
//  LiveTeamsService.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

final class TeamsServiceLive: TeamsService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientFactory.withRateLimiter()) {
        self.httpClient = httpClient
    }
    
    // MARK: - Teams
    @concurrent
    func listTeams() async throws -> [Team] {
        let (data, urlResponse) = try await httpClient.send(to: ListTeamsEndpoint())
        try checkResponse(urlResponse)
        
        let teamsData = try JSONDecoder().decode(ListTeamsRoot.self, from: data)
        
        let teams: [Team] = teamsData.data.map(TeamResponse.mapToTeam)
        
        return teams
    }
    
    // MARK: - Games
    @concurrent
    func listGames(forTeam teamId: Int, cursor: Int? = nil) async throws -> ([TeamGame], Int?) {
        let (data, urlResponse) = try await httpClient.send(to: ListTeamDetailsEndpoint(teamID: teamId, cursor: cursor))
        try checkResponse(urlResponse)
        
        let gameData = try JSONDecoder().decode(BasePaginatedResponse<Game>.self, from: data)
        let teamGames = gameData.data.map(Game.mapToTeamGame)
        
        return (teamGames, gameData.meta.nextCursor)
    }
    
    // MARK: - Players
    @concurrent
    func searchPlayers(query: String) async throws -> [Player] {
        let (data, urlResponse) = try await httpClient.send(to: SearchPlayerEndpoint(query: query))
        try checkResponse(urlResponse)
        
        let playersResponse = try JSONDecoder().decode(BasePaginatedResponse<PlayerResponse>.self, from: data)
        let players = playersResponse.data.map(PlayerResponse.mapToPlayer)
        
        return players
    }
    
    
    
    // MARK: - Shared
    private nonisolated func checkResponse(_ urlResponse: URLResponse?, forStatus statuses: [Int] = Array(200..<300)) throws {
        guard let httpResponse = urlResponse as? HTTPURLResponse else { throw URLError(.unknown) }
        guard statuses.contains(httpResponse.statusCode) else {
            print("BAD RESPONSE: \(httpResponse)")
            throw URLError(.badServerResponse)
        }
    }
}

nonisolated extension URL {
    func appendingCursor(_ cursor: Int?) -> URL? {
        guard let cursor else { return self }
        let withCursor = self
        return withCursor.appendQuery(items: [ URLQueryItem(name: "cursor", value: String(cursor)) ])
    }
    
    func appendingTeamID(_ id: Int) -> URL? {
        let withTeamIDs = self
        return withTeamIDs.appendQuery(items: [ URLQueryItem(name: "team_ids[]", value: String(id)) ])
    }
    
    func appendingSearch(_ query: String) -> URL? {
        let withSearch = self
        return withSearch.appendQuery(items: [ URLQueryItem(name: "search", value: query) ])
    }
}
