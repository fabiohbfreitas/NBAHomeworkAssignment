//
//  HTTPClient.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

protocol HTTPClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

protocol Endpoint: Sendable {
    func makeRequest() throws -> URLRequest
}
