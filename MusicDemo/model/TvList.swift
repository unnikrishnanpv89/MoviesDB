//
//  TvList.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/22.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class TvList: Object,Mappable {
    @objc dynamic var page: Int = 0
    var results: [TVDetails] = []
    @objc dynamic var totalPages: Int = 0
    @objc dynamic var totalResults: Int = 0

    required convenience init?(map: ObjectMapper.Map) {
            self.init()
        }
    
    override class func primaryKey() -> String {
            return "page"
    }
    
    func mapping(map: ObjectMapper.Map) {
        page            <- map["page"]
        results         <- map["results"]
        totalPages      <- map["total_pages"]
        totalResults    <- map["total_results"]
    }
}

class TVDetails: Object,Mappable {

    required convenience init?(map: ObjectMapper.Map) {
            self.init()
        }
    
    override class func primaryKey() -> String {
            return "id"
    }
    
    @objc dynamic var backdropPath: String?
    @objc dynamic var firstAirDate: String?
    var genreIDS: [Int] = []
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var originCountry: [String] = []
    @objc dynamic var originalLanguage: String = ""
    @objc dynamic var originalName = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var posterPath: String?
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var voteCount: Int = 0
    @objc dynamic var  mediaType: String = ""

    func mapping(map: ObjectMapper.Map) {
        backdropPath        <- map["backdrop_path"]
        firstAirDate        <- map["first_air_date"]
        genreIDS            <- map["genre_ids"]
        id                  <- map["id"]
        name                <- map["name"]
        originCountry       <- map["origin_country"]
        originalLanguage    <- map["original_language"]
        originalName        <- map["original_name"]
        overview            <- map["overview"]
        popularity          <- map["popularity"]
        posterPath          <- map["poster_path"]
        voteAverage         <- map["vote_average"]
        voteCount           <- map["vote_count"]
        mediaType           <- map["media_type"]
    }
}
