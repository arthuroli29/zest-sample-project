//
//  PlaceListService.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import Foundation

protocol PlaceListServiceProtocol {
    func getPlaceList() async throws -> PlaceListResponse
}

struct PlaceListService: PlaceListServiceProtocol {
    enum ServiceError: Error {
        case invalidURL
    }

    private static let baseURL = "https://us-central1-notswarm-c7978.cloudfunctions.net"

    func getPlaceList() async throws -> PlaceListResponse {
        guard let url = URL(string: "\(Self.baseURL)/mockGetPlaceListItems") else {
            throw ServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any?] = ["data": nil]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(PlaceListResponse.self, from: data)

        return response
    }
}
