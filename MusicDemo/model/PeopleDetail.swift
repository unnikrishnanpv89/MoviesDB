//
//  PeopleDetail.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/07.
//

import Foundation

struct PeopleDetail: Decodable {
    var adult: Bool
    var alsoKnownAs: [String]
    var biography, birthday: String?
    var deathday: String?
    var gender: Int
    var homepage: String?
    var id: Int
    var name: String
    var imdbID, knownForDepartment, placeOfBirth: String?
    var popularity: Double?
    var profilePath: String

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}
