//
//  HTTPClientFactory.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 15/02/26.
//

import Foundation
import Alamofire

struct HTTPClientFactory {
    private init(){}
    
    static func withRateLimiter() -> HTTPClient {
        return RateLimitDecorator(decorating: Session.default)
    }
}
