//
//  ErrorView.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundColor(.orange)

                Text("Something went wrong")
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onRetry) {
                Text("Retry")
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "This is a test error", onRetry: { print("Retry tapped") })
}
