//
//  RateLimitDecorator.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 15/02/26.
//


import SwiftUI

final class RateLimitDecorator<T: HTTPClient>: HTTPClient {
    private let client: T
    private let maxRetries: Int
    
    init(decorating client: T, maxRetries: Int = 2) {
        self.client = client
        self.maxRetries = maxRetries
    }
    
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await performSend(request, attempt: 0)
    }
    
    private func performSend(_ request: URLRequest, attempt: Int) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await client.send(request)
        
        if response.statusCode == 429 && attempt < maxRetries {
            if let delay = retryAfterDelay(from: response) {
                print("Rate limit hit (429). Retry attempt \(attempt + 1)/\(self.maxRetries). Waiting \(delay) seconds.")
                
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                return try await performSend(request, attempt: attempt + 1)
            }
        }
        
        return (data, response)
    }
    
    private func retryAfterDelay(from response: HTTPURLResponse) -> TimeInterval? {
        guard let retryAfterHeader = response.value(forHTTPHeaderField: "Retry-After") else {
            return nil
        }
        
        return TimeInterval(retryAfterHeader)
    }
}
