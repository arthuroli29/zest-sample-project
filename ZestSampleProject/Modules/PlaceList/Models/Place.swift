//
//  Place.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import Foundation

// MARK: - Item
struct Place: Codable, Identifiable, Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let createdAt: String
    let contributor: Contributor
    let note: String?
    let googlePlaceID: String
    let displayName: String
    let formattedAddress: String
    let location: Location
    let addressComponents: [AddressComponent]
    let placeTypes: [String]
    let website: String
    let phoneNumber: String
    let localAreaName: String
    let dateVisited: String?
    let datetimeVisited: String?
    let rating: Double?
    let isManual: Bool?
    let resyLink: ResyLink?
    let openTableLink: String?

    enum CodingKeys: String, CodingKey {
        case id, createdAt, contributor, note
        case googlePlaceID = "googlePlaceId"
        case displayName, formattedAddress, location, addressComponents, placeTypes, website, phoneNumber, localAreaName, dateVisited, datetimeVisited, rating, isManual, resyLink, openTableLink
    }

    // Note: This formatting approach works for current API responses but may need
    // reconsideration if place types become more dynamic or varied. A better long-term
    // solution would be for the backend to return display-ready type names.
    var formattedPlaceTypes: [String] {
        placeTypes
            .map { type in
                type
                    .replacingOccurrences(of: "_", with: " ")
                    .capitalized
                    .replacingOccurrences(of: " Restaurant", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            .filter { !$0.isEmpty }
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let types: [String]
    let longText: String
    let shortText: String
    let languageCode: LanguageCode
}

enum LanguageCode: String, Codable {
    case en = "en"
    case enUS = "en-US"
}

// MARK: - Contributor
struct Contributor: Codable {
    let id: String
    let firstName: String
}

// MARK: - Location
struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - ResyLink
struct ResyLink: Codable {
    let web: String
    let deep: String
}

extension Place {
    static let mock = Place(
        id: "plc_123456",
        createdAt: "2025-10-26T21:00:00Z",
        contributor: Contributor(
            id: "PyYILXfyMYZePdRPm5VFizkWLbU2",
            firstName: "Alex"
        ),
        note: "Cozy atmosphere and amazing coffee!",
        googlePlaceID: "ChIJN1t_tDeuEmsRUsoyG83frY4",
        displayName: "Lakeside Café Bistro",
        formattedAddress: "1234 Main Street, Downtown, Denver, CO, USA",
        location: Location(latitude: 39.7392, longitude: -104.9903),
        addressComponents: [
            AddressComponent(types: ["street_number"], longText: "1234", shortText: "1234", languageCode: .enUS),
            AddressComponent(types: ["route"], longText: "Main Street", shortText: "Main St", languageCode: .en),
            AddressComponent(types: ["locality"], longText: "Denver", shortText: "Denver", languageCode: .en),
            AddressComponent(types: ["administrative_area_level_1"], longText: "Colorado", shortText: "CO", languageCode: .en),
            AddressComponent(types: ["country"], longText: "United States", shortText: "US", languageCode: .en)
        ],
        placeTypes: ["cafe", "restaurant", "point_of_interest", "establishment", "american", "bar"],
        website: "https://www.lakesidecafebistro.com",
        phoneNumber: "+1 303-555-0173",
        localAreaName: "Downtown",
        dateVisited: "2025-09-20",
        datetimeVisited: "2025-09-20T15:30:00Z",
        rating: 4.7,
        isManual: false,
        resyLink: nil,
        openTableLink: "https://www.opentable.com/r/lakeside-cafe-bistro"
    )
}
