//
//  SearchPlayerModels.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import Foundation

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
