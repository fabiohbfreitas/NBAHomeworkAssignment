//
//  ProcessInfo+IsPreview.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI

extension ProcessInfo {
    static func isPreview() -> Bool {
        guard let result = processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] else { return false }
        return result == "1"
    }
}