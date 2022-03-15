//
//  TrendingResult.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/07.
//

import Foundation

struct TrendingResults: Decodable {
    var page: Int
    var results: [Trending]
    var totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Trending: Decodable {
    var releaseDate: String?
    var adult: Bool?
    var backdropPath: String
    var genreIDS: [Int]
    var voteCount: Int
    var originalLanguage: String
    var originalTitle: String?
    var posterPath: String
    var voteAverage: Double
    var video: Bool?
    var id: Int
    var title: String?
    var overview: String
    var popularity: Double
    var mediaType: String
    var firstAirDate, name: String?
    var originCountry: [String]?
    var originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case releaseDate = "release_date"
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case video, id, title, overview, popularity
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
    }
}
