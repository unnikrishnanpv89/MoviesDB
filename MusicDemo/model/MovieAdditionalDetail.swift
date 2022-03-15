//
//  MovieAdditionalDetail.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/02.
//

struct MovieAdditionalDetails: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    struct BelongsToCollection: Decodable {
        var id: Int?
        var name, posterPath, backdropPath: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage, originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    struct ProductionCompany: Decodable {
        var id: Int?
        var logoPath, name, originCountry: String?

        enum CodingKeys: String, CodingKey {
            case id
            case logoPath = "logo_path"
            case name
            case originCountry = "origin_country"
        }
    }

    let productionCountries: [ProductionCountry]?
    struct ProductionCountry: Codable {
        var iso3166_1, name: String?

        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    struct SpokenLanguage: Codable {
        var englishName, iso639_1, name: String?

        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case belongsToCollection = "belongs_to_collection"
            case budget, genres, homepage, id
            case imdbID = "imdb_id"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
            case releaseDate = "release_date"
            case revenue, runtime
            case spokenLanguages = "spoken_languages"
            case status, tagline, title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
}
