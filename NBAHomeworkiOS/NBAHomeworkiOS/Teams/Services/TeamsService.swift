//
//  TeamsService.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

protocol TeamsService {
    func listTeams() async throws -> [Team]
    func listGames(forTeam teamId: Int, cursor: Int?) async throws -> ([TeamGame], Int?)
    func searchPlayers(query: String) async throws -> [Player]
}


