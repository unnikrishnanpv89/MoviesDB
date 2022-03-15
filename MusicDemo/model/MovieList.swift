//
//  MovieList.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/22.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class MovieList: Object,Mappable {
    @objc dynamic var page: Int = 0
    var results: [MovieDetail] = []
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

class MovieDetail: Object,Mappable {
    
    required convenience init?(map: ObjectMapper.Map) {
            self.init()
    }
    
    override class func primaryKey() -> String {
            return "id"
    }
    
    var adult: Bool? = nil
    @objc dynamic var  backdropPath: String? = nil
    var genreIDS: [Int] = []
    @objc dynamic var  id: Int = 0
    @objc dynamic var  originalLanguage: String = ""
    @objc dynamic var  originalTitle = "", overview: String = ""
    @objc dynamic var  popularity: Double = 0.0
    @objc dynamic var  posterPath: String? = nil
    @objc dynamic var  releaseDate: String? = nil
    @objc dynamic var  title: String = ""
    @objc dynamic var  video: Bool = false
    @objc dynamic var  voteAverage: Double = 0.0
    @objc dynamic var  voteCount: Int = 0
    @objc dynamic var  mediaType: String = ""
    
    func mapping(map: ObjectMapper.Map) {
        adult               <- map["adult"]
        backdropPath        <- map["backdrop_path"]
        genreIDS            <- map["genre_ids"]
        id                  <- map["id"]
        originalLanguage    <- map["original_language"]
        originalTitle       <- map["original_title"]
        overview            <- map["overview"]
        popularity          <- map["popularity"]
        releaseDate         <- map["release_date"]
        title               <- map["title"]
        video               <- map["video"]
        posterPath          <- map["poster_path"]
        voteAverage         <- map["vote_average"]
        voteCount           <- map["vote_count"]
        mediaType           <- map["media_type"]
    }
}
