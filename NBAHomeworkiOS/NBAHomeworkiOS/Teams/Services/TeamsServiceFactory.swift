//
//  TeamsServiceFactory.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import Foundation

struct TeamsServiceFactory {
    private init() {}
    
    static func makeTeamService() -> TeamsService {
        return ProcessInfo.isPreview() ? TeamsServiceInMemory() : TeamsServiceLive()
    }
}
