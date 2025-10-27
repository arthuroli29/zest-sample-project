//
//  PlaceListResponse.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import Foundation

// MARK: - Response
struct PlaceListResponse: Codable {
    let result: PlaceList
}

// MARK: - Result
struct PlaceList: Codable {
    let listID: String
    let items: [Place]

    enum CodingKeys: String, CodingKey {
        case listID = "listId"
        case items
    }
}
