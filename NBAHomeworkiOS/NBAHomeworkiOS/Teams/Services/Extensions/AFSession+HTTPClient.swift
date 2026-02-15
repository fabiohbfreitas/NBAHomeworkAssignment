//
//  AFSession+HTTPClient.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 15/02/26.
//


import SwiftUI
import Alamofire

extension Session: HTTPClient {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let dataTask = self.request(request)
            .serializingData()
        let response = await dataTask.response
        switch response.result {
        case .success(let data):
            guard let httpResponse = response.response else {
                throw AFError.responseValidationFailed(reason: .unacceptableContentType(acceptableContentTypes: [], responseContentType: ""))
            }
            return (data, httpResponse)
            
        case .failure(let error):
            throw error
        }
    }
}
