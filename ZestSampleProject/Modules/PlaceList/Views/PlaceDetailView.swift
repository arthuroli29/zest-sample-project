//
//  PlaceDetailView.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import SwiftUI

// MARK: - Place Detail View
struct PlaceDetailView: View {
    let place: Place
    let onDismiss: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title and close button
                HStack(alignment: .top) {
                    Text(place.displayName)
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }

                Text(place.formattedAddress)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                FlowLayout(spacing: 6) {
                    ForEach(place.formattedPlaceTypes, id: \.self) { type in
                        Text(type)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .clipShape(Capsule())
                    }
                }

                if let website = URL(string: place.website) {
                    Link(destination: website) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Visit Website")
                        }
                        .foregroundColor(.blue)
                    }
                }

                HStack {
                    Image(systemName: "phone")
                    Text(place.phoneNumber)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    PlaceDetailView(place: Place.mock, onDismiss: {})
}
