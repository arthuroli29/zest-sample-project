//
//  PlaceListSheetView.swift
//  ZestSampleProject
//
//  Created by Alexander Moller on 10/16/25.
//

import SwiftUI

struct PlaceListSheetView: View {
    @Environment(PlaceListViewModel.self) var placeListManager

    var body: some View {
        VStack {
            Spacer().frame(height: 10)

            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)

            Spacer().frame(height: 5)

            if placeListManager.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = placeListManager.errorMessage {
                ErrorView(message: errorMessage, onRetry: {
                    Task {
                        await placeListManager.fetchPlaceList()
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let selectedPlace = placeListManager.selectedPlace {
                PlaceDetailView(place: selectedPlace, onDismiss: {
                    placeListManager.selectedPlace = nil
                })
            } else if let places = placeListManager.placeList?.items, !places.isEmpty {
                List {
                    ForEach(places) { place in
                        PlaceRowView(place: place)
                    }
                }
                .listStyle(.plain)
            }
        }
        .animation(.easeOut(duration: 0.2), value: placeListManager.selectedPlace)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlaceListSheetView()
        .environment(PlaceListViewModel())
}
