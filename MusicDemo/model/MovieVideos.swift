//
//  MovieVideos.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/02.
//

struct MovieVideo: Decodable {
    var id: Int?
    var results: [Result]?
}

struct Result: Decodable{
    var iso639_1, iso3166_1, name: String?
    var key: String
    var site: String
    var size: Int?
    var type: String
    var official: Bool
    var publishedAt, id: String?
}
