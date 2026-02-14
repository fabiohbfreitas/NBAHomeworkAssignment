//
//  Credentials.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import Foundation

struct Credentials {
    ///
    /// The API used for this Assignment requires an Key for accessing any data.
    /// The current setup is used considering the scope of a homework assignment and should **NOT BE USED IN PRODUCTION** setups.
    ///
    /// How to get started: https://www.balldontlie.io/blog/getting-started/
    /// Official documentation: https://www.balldontlie.io/docs/
    ///
    static nonisolated let API_KEY = "" // API KEY SHOULD GO HERE!
    
    static func preflightCheck() {
        if Credentials.API_KEY.isEmpty && !ProcessInfo.isPreview() {
            preconditionFailure("LIVE API REQUIRES API_KEY SETUP, please check https://www.balldontlie.io/blog/getting-started/")
        }
    }
}
