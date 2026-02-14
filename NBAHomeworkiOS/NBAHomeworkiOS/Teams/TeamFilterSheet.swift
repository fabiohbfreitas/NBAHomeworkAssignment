//
//  FilterSheet.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//


import SwiftUI

struct TeamFilterSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var teamsViewModel: TeamsViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Order Teams by", selection: $teamsViewModel.filter) {
                    ForEach(SortingFilter.allCases, id: \.rawValue) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                Button("Apply filters") {
                    teamsViewModel.applyFilters()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .listRowSeparator(.hidden)
        }
    }
}
