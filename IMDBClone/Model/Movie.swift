//
//  Movie.swift
//  IMDBClone
//
//  Created by Mina on 02/02/2023.
//

import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let items: [Movie]?
    let errorMessage: String?
}

// MARK: - Item
struct Movie: Codable {
    var id, rank, title, fullTitle: String?
    var year: String?
    var image: String?
    var crew, imDBRating, imDBRatingCount: String?
    
    init() {
    }

    enum CodingKeys: String, CodingKey {
        case id, rank, title, fullTitle, year, image, crew
        case imDBRating = "imDbRating"
        case imDBRatingCount = "imDbRatingCount"
    }
}
