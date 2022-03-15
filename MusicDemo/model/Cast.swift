import Foundation

// MARK: - Cast
struct Cast: Decodable {
    var id: Int
    var cast, crew: [CastElement]
}

// MARK: - CastElement
struct CastElement: Decodable {
    var adult: Bool
    var gender, id: Int
    var known_for_department: String?
    var name, original_name: String
    var popularity: Double
    var profile_path: String?
    var cast_id: Int?
    var character: String?
    var credit_id: String
    var order: Int?
    var department: String?
    var job: String?
}
