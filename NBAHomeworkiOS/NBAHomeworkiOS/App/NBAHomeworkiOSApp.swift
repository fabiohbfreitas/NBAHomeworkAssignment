//
//  NBAHomeworkiOSApp.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 13/02/26.
//

import SwiftUI

@main
struct NBAHomeworkiOSApp: App {
    
    init() {
        Credentials.preflightCheck()
    }
    
    var body: some Scene {
        WindowGroup {
            TeamsHomeView.makeHomeView()
        }
    }
}
