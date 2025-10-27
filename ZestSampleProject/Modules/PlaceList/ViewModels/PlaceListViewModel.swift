//
//  PlaceListViewModel.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import Foundation

@Observable
class PlaceListViewModel {
    let placeListService: PlaceListServiceProtocol
    var placeList: PlaceList?
    var selectedPlace: Place?
    var errorMessage: String?
    var isLoading = true

    init(placeListService: PlaceListServiceProtocol = PlaceListService()) {
        self.placeListService = placeListService
        Task {
            await fetchPlaceList()
        }
    }

    func fetchPlaceList() async {
        errorMessage = nil
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            placeList = try await placeListService.getPlaceList().result
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}
