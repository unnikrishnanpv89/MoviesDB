//
//  CreditDetails.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/07.
//

import Foundation

struct Credits: Decodable {
    var cast, crew: [Credit]
    var id: Int
}

struct Credit: Decodable {
    var genreIDS: [Int]
    var originalLanguage: String
    var originalTitle: String?
    var posterPath: String?
    var video: Bool?
    var id: Int
    var overview: String
    var releaseDate: String?
    var voteCount: Int
    var voteAverage: Double
    var adult: Bool?
    var backdropPath: String?
    var title: String?
    var popularity: Double
    var character: String?
    var creditID: String
    var order: Int?
    var mediaType: String
    var firstAirDate, originalName: String?
    var originCountry: [String]?
    var name: String?
    var episodeCount: Int?
    var department, job: String?

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case video, id, overview
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case adult
        case backdropPath = "backdrop_path"
        case title, popularity, character
        case creditID = "credit_id"
        case order
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originalName = "original_name"
        case originCountry = "origin_country"
        case name
        case episodeCount = "episode_count"
        case department, job
    }
}
