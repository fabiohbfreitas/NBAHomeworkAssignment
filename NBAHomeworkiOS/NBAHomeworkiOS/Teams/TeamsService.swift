//
//  TeamsService.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI
import Combine

final class TeamsService {
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
        
        static func toTeam(_ response: TeamResponse) -> Team {
            Team(
                id: response.id,
                fullName: response.conference,
                city: response.city,
                conference: response.fullName
            )
        }
    }
    
    
    @concurrent
    func listTeams() async throws -> [Team] {
        var request = URLRequest(url: URL(string: "https://api.balldontlie.io/v1/teams")!)
        request.addValue(Credentials.API_KEY, forHTTPHeaderField: "Authorization")
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        try checkResponse(urlResponse)
        
        let teamsData = try JSONDecoder().decode(ListTeamsRoot.self, from: data)
        
        let teams: [Team] = teamsData.data.map(TeamResponse.toTeam)
        
        return teams
    }
    
    private nonisolated func checkResponse(_ urlResponse: URLResponse?, forStatus statuses: [Int] = Array(200..<300)) throws {
        let httpResponse = urlResponse as? HTTPURLResponse
        guard statuses.contains(httpResponse?.statusCode ?? 500) else {
            throw URLError(.badServerResponse)
        }
    }
}
