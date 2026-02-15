//
//  URLSession+HTTPClient.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI

// MARK: - URLSession + HTTPClient
extension URLSession: HTTPClient {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (body, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        return (body, httpResponse)
    }
}

// MARK: - URLSession + withAuthorization
extension URLRequest {
    func with(authorization apiKey: String) -> URLRequest {
        var copy = self
        copy.addValue(apiKey, forHTTPHeaderField: "Authorization")
        return copy
    }
}

// MARK: - HTTPClient + sendToEndoint
extension HTTPClient {
    func send(to endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        return try await send(try endpoint.makeRequest())
    }
}
