//
//  ListTeamDetailsModels.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import Foundation

nonisolated struct BasePaginatedResponse<T: Codable>: Codable {
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
