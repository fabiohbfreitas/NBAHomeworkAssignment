//
//  TeamError.swift
//  NBAHomeworkiOS
//
//  Created by Fabio Freitas on 14/02/26.
//

import SwiftUI

struct ErrorWithRetry: View {
    let title: String
    let tryAgainAction: (() -> Void)
    
    var body: some View {
        VStack {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
            Button("Try again") {
                tryAgainAction()
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.red).opacity(0.1))
    }
}

#Preview {
    ErrorWithRetry(
        title: "Error when fetching from API",
        tryAgainAction: { print("Did tap try again") }
    )
}
