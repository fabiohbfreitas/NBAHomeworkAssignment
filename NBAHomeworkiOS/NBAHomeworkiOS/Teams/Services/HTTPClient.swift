//
//  HTTPClient.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI

protocol HTTPClient: Sendable {
    func makeRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

extension URLSession: HTTPClient {
    func makeRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (body, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        return (body, httpResponse)
    }
}
