//
//  LiveTeamsService.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

final class TeamsServiceLive: TeamsService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
    
    // MARK: - Teams
    nonisolated struct ListTeamsRoot: Codable {
        let data: [TeamResponse]
    }
    
    nonisolated struct TeamResponse: Codable {
        let id: Int
        let conference, division, city, name: String
        let fullName, abbreviation: String
        
        enum CodingKeys: String, CodingKey {
            case id, conference, division, city, name
            case fullName = "full_name"
            case abbreviation
        }
        
        static func mapToTeam(_ response: TeamResponse) -> Team {
            Team(
                id: response.id,
                fullName: response.fullName,
                city: response.city,
                conference: response.conference
            )
        }
    }
    
    @concurrent
    func listTeams() async throws -> [Team] {
        var request = URLRequest(url: URL(string: "https://api.balldontlie.io/v1/teams")!)
        request.addValue(Credentials.API_KEY, forHTTPHeaderField: "Authorization")
        
        let (data, urlResponse) = try await httpClient.makeRequest(request)
        try checkResponse(urlResponse)
        
        let teamsData = try JSONDecoder().decode(ListTeamsRoot.self, from: data)
        
        let teams: [Team] = teamsData.data.map(TeamResponse.mapToTeam)
        
        return teams
    }
    
    // MARK: - Games
    nonisolated struct BaseResponse<T: Codable>: Codable {
        let data: [T]
        let meta: Meta
    }
    
    nonisolated struct Game: Codable {
        let id, homeTeamScore, visitorTeamScore: Int
        let homeTeam, visitorTeam: TeamResponse
        
        enum CodingKeys: String, CodingKey {
            case id
            case homeTeamScore = "home_team_score"
            case visitorTeamScore = "visitor_team_score"
            case homeTeam = "home_team"
            case visitorTeam = "visitor_team"
        }
        
        static func mapToTeamGame(_ game: Self) -> TeamGame {
            TeamGame(
                id: game.id,
                homeTeam: game.homeTeam.fullName,
                homeScore: String(game.homeTeamScore),
                visitorTeam: game.visitorTeam.fullName,
                visitorScore: String(game.visitorTeamScore)
            )
        }
    }
    
    struct Meta: Codable {
        let nextCursor: Int?
        let perPage: Int
        
        enum CodingKeys: String, CodingKey {
            case nextCursor = "next_cursor"
            case perPage = "per_page"
        }
    }
    
    @concurrent
    func listGames(forTeam teamId: Int, cursor: Int? = nil) async throws -> ([TeamGame], Int?) {
        let url = URL(string: "https://api.balldontlie.io/v1/games")!.appendingTeamID(teamId)!.appendingCursor(cursor)!
        
        var request = URLRequest(url: url)
        request.addValue(Credentials.API_KEY, forHTTPHeaderField: "Authorization")
        
        let (data, urlResponse) = try await httpClient.makeRequest(request)
        try checkResponse(urlResponse)
        
        let gameData = try JSONDecoder().decode(BaseResponse<Game>.self, from: data)
        let teamGames = gameData.data.map(Game.mapToTeamGame)
        
        return (teamGames, gameData.meta.nextCursor)
    }
    
    // MARK: - Players
    nonisolated struct PlayerResponse: Codable {
        let id: Int
        let firstName, lastName: String
        let team: TeamResponse
        
        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case team
        }
        
        static func mapToPlayer(_ response: Self) -> Player {
            Player(
                id: response.id,
                firstName: response.firstName,
                lastName: response.lastName,
                team: TeamResponse.mapToTeam(response.team)
            )
        }
    }
    
    @concurrent
    func searchPlayers(query: String) async throws -> [Player] {
        let url = URL(string: "https://api.balldontlie.io/v1/players")!.appendingSearch(query.lowercased())!
        
        var request = URLRequest(url: url)
        request.addValue(Credentials.API_KEY, forHTTPHeaderField: "Authorization")
        
        let (data, urlResponse) = try await httpClient.makeRequest(request)
        try checkResponse(urlResponse)
        
        let playersResponse = try JSONDecoder().decode(BaseResponse<PlayerResponse>.self, from: data)
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
