//
//  PlaceRowView.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import SwiftUI

struct PlaceRowView: View {
    @Environment(PlaceListViewModel.self) var placeListManager

    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(place.displayName)
                .font(.headline)
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
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            placeListManager.selectedPlace = place
        }
    }
}

#Preview {
    PlaceRowView(place: .mock)
        .environment(PlaceListViewModel())
        .padding()
}
