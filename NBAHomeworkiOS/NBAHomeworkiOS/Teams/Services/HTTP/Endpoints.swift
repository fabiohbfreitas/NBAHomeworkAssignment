//
//  Endpoints.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI

// MARK: - List Teams Endpoint
struct ListTeamsEndpoint: Endpoint {
    let baseURL: String
    let apiKey: String
    
    init() {
        self.baseURL = "https://api.balldontlie.io/v1/teams"
        self.apiKey = Credentials.API_KEY
    }
    
    func makeRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL) else { throw URLError(.badURL) }
        let request = URLRequest(url: url).with(authorization: apiKey)
        return request
    }
}

// MARK: - List Team Details/Games Endpoint
struct ListTeamDetailsEndpoint: Endpoint {
    let baseURL: String
    let apiKey: String
    let teamID: Int
    let cursor: Int?
    
    init(teamID: Int, cursor: Int?) {
        self.baseURL = "https://api.balldontlie.io/v1/games"
        self.apiKey = Credentials.API_KEY
        self.teamID = teamID
        self.cursor = cursor
    }
    
    func makeRequest() throws -> URLRequest {
        guard let initial = URL(string: baseURL),
              let url = initial.appendingTeamID(teamID)?.appendingCursor(cursor)
        else { throw URLError(.badURL) }
        
        let request = URLRequest(url: url).with(authorization: apiKey)
        return request
    }
}

// MARK: - Search Player Endpoint
struct SearchPlayerEndpoint: Endpoint {
    let baseURL: String
    let apiKey: String
    let query: String
    
    init(query: String) {
        self.baseURL = "https://api.balldontlie.io/v1/players"
        self.apiKey = Credentials.API_KEY
        self.query = query
    }
    
    func makeRequest() throws -> URLRequest {
        guard let initial = URL(string: baseURL),
              let url = initial.appendingSearch(query.lowercased())
        else { throw URLError(.badURL) }
        
        let request = URLRequest(url: url).with(authorization: apiKey)
        return request
    }
}
