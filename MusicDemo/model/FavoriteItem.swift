//
//  FavoriteItemMovie.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/08.
//

import Foundation
import ObjectMapper

struct FavItem: Mappable, Hashable {
    
    mutating func mapping(map: Map) {
        <#code#>
    }
    
    
    required convenience init?(map: ObjectMapper.Map) {
            self.init()
    }
    
    override class func primaryKey() -> String {
            return "id"
    }
    
    var id: Int
    var originalTitle: String
    var popularity: Double
    var posterPath: String?
    var voteCount: Int
    var mediaType: String
    var voteAverage: Double?
    var releaseDate: String?
}
