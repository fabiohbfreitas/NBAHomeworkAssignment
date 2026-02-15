//
//  ListTeamsModels.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import Foundation

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
