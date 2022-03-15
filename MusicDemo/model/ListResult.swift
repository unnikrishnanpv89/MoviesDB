//
//  ListResult.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/08.
//

import Foundation

struct ListResult: Decodable {
    var averageRating: Double?
    var backdropPath: String?
    var comments: [String: String?]?
    var createdBy: CreatedBy?
    var listResultDescription: String?
    var id: Int
    var iso3166_1, iso639_1, name: String?
    var objectIDS: [String: String?]
    var page: Int
    var posterPath: String?
    var listResultPublic: Bool
    var results: [ResultList]
    var revenue, runtime: Int?
    var sortBy: String?
    var totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case averageRating = "average_rating"
        case backdropPath = "backdrop_path"
        case comments
        case createdBy = "created_by"
        case listResultDescription = "description"
        case id
        case iso3166_1 = "iso_3166_1"
        case iso639_1 = "iso_639_1"
        case name
        case objectIDS = "object_ids"
        case page
        case posterPath = "poster_path"
        case listResultPublic = "public"
        case results, revenue, runtime
        case sortBy = "sort_by"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct CreatedBy: Decodable {
    var gravatarHash, id, name, username: String

    enum CodingKeys: String, CodingKey {
        case gravatarHash = "gravatar_hash"
        case id, name, username
    }
}

struct ResultList: Decodable {
    var adult: Bool?
    var backdropPath: String
    var genreIDS: [Int]
    var id: Int
    var mediaType, originalLanguage, overview: String
    var popularity: Double
    var posterPath, releaseDate, originalTitle: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double
    var voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


enum ListId: Int, CaseIterable{
    case Streaming = 8194484
    case OnTV = 8194483
    case ForRent = 8194482
    case InTeatres = 8194481
    case ftw_movie = 8194488
    case ftw_tv = 8194487
    case trailer_streaming = 8194489
    case Trailer_ONTV = 8194490
    case Trailer_ForRent = 8194491
    case Trailer_InTeatre = 8194492
}
