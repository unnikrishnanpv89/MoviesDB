//
//  TVAdditionalDetail.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/02.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tVAdditionalDetail = try TVAdditionalDetail(json)
struct TVAdditionalDetail: Decodable {
    var adult: Bool?
    var backdropPath: String?
    var createdBy: [CreatedBy]?
    struct CreatedBy: Decodable {
        var id: Int
        var creditID, name: String?
        var gender: Int
        var profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case creditID = "credit_id"
            case name, gender
            case profilePath = "profile_path"
        }
    }
    var episodeRunTime: [Int]?
    var firstAirDate: String?
    var genres: [Genre]?
    var homepage: String?
    var id: Int
    var inProduction: Bool?
    var languages: [String]
    var lastAirDate: String?
    var lastEpisodeToAir: TEpisodeToAir?
    struct TEpisodeToAir: Decodable {
        var airDate: String
        var episodeNumber, id: Int
        var name, overview, productionCode: String
        var seasonNumber: Int
        var stillPath: String?
        var voteAverage: Double?
        var voteCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case airDate = "air_date"
            case episodeNumber = "episode_number"
            case id, name, overview
            case productionCode = "production_code"
            case seasonNumber = "season_number"
            case stillPath = "still_path"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
    var name: String
    var nextEpisodeToAir: TEpisodeToAir?
    var networks: [Network]?
    struct Network: Decodable {
        var name: String
        var id: Int
        var logoPath: String?
        var originCountry: String?
        
        enum CodingKeys: String, CodingKey {
            case name, id
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
    }
    var numberOfEpisodes, numberOfSeasons: Int?
    var originCountry: [String]?
    var originalLanguage, originalName: String?
    var overview: String
    var popularity: Double
    var posterPath: String?
    var productionCompanies: [Network]?
    var productionCountries: [ProductionCountry]?
    struct ProductionCountry: Decodable{
        var iso3166_1, name: String
        
        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }
    var seasons: [Season]?
    struct Season: Decodable {
        var airDate: String?
        var episodeCount: Int?
        var id: Int
        var name, overview: String
        var posterPath: String?
        var seasonNumber: Int?
        
        enum CodingKeys: String, CodingKey {
            case airDate = "air_date"
            case episodeCount = "episode_count"
            case id, name, overview
            case posterPath = "poster_path"
            case seasonNumber = "season_number"
        }
    }
    var spokenLanguages: [SpokenLanguage]?
    struct SpokenLanguage: Decodable {
        var englishName, iso639_1, name: String
        
        
        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
    var status, tagline, type: String?
    var voteAverage: Double?
    var voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case createdBy = "created_by"
            case episodeRunTime = "episode_run_time"
            case firstAirDate = "first_air_date"
            case genres, homepage, id
            case inProduction = "in_production"
            case languages
            case lastAirDate = "last_air_date"
            case lastEpisodeToAir = "last_episode_to_air"
            case name
            case nextEpisodeToAir = "next_episode_to_air"
            case networks
            case numberOfEpisodes = "number_of_episodes"
            case numberOfSeasons = "number_of_seasons"
            case originCountry = "origin_country"
            case originalLanguage = "original_language"
            case originalName = "original_name"
            case overview, popularity
            case posterPath = "poster_path"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
            case seasons
            case spokenLanguages = "spoken_languages"
            case status, tagline, type
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
}

