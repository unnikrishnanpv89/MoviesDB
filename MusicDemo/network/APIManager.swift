//
//  API.swift
//  SimpleAFire
//
//  Created by Shubham Singh on 17/04/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// model for a Resource
struct NewToken: Decodable {
    let success: Bool
    let expires_at: String
    let request_token: String
}

// model for a Resource
struct Resource: Decodable {
    let username: String
    let password: String
    let requestToken: String
}

struct URLResource: Decodable {
    let category: String
    let genreId: Int
    let query: String
    let pageNum: Int
}

struct ErrorResponse: Decodable {
    let success: Bool
    let status_code: Int
    let status_message: String
}

struct UserAuth: Decodable{
    let success: Bool
    let expires_at: String
    let request_token: String
}

struct GuestSession: Decodable{
    let success: Bool
    let expires_at: String
    let guest_session_id: String
}

struct Genre: Decodable{
    let id: Int
    let name: String
}

struct GenreResponse: Decodable{
    let genres: [Genre]
}

enum Time_Window: String{
    case day =  "day"
    case week = "week"
}

var api_key : String = "23ccbc6ba23fbb3be9bc3b51436d454f"

// creating an enum which contains the API requests and it's calling function
enum APIManager: URLRequestConvertible {

    case getRequestToken
    
    case validateWithLogin(res: Resource)
    
    case createGuestSession
    
    case getGenre(category: GenreParent)
    
    case getGenreMovieList(resource: URLResource)
    
    case searchMovie(resource: URLResource)
    
    case getAdditionalDetail(id: Int, category: GenreParent)
    
    case getMovieVideos(movieId: Int, category: GenreParent)
    
    case getCredits(movieId: Int, category: GenreParent)
    
    case getRecommendations(resource: URLResource)
    
    case getCastDetail(id: Int)
    
    case getPersonCredits(id: Int)
    
    case getTrending(window: Time_Window)
    
    case getList(id: ListId)
    
    // specifying the methods for each API
    var method: HTTPMethod {
        switch self {
        case .validateWithLogin:
            return .post
        default:
            return .get
        }
    }
    
    // If the API requires body or queryString encoding, it can be specified here
    var encoding : URLEncoding {
        switch self {
        default:
            return .default
        }
    }
    
    func findUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: api_key),
        ]
        switch self{
            case .getRequestToken:
                components.path = "/3/authentication/token/new"
                break
            case .validateWithLogin:
                components.path = "/3/authentication/token/validate_with_login"
                break
            case .createGuestSession:
                components.path = "/3/authentication/guest_session/new"
                break
            case .getGenre(let category):
                components.path = "/3/genre/\(category.rawValue)/list"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getGenreMovieList(let resource):
                components.path = "/3/discover/\(resource.category)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                components.queryItems?.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
                components.queryItems?.append(URLQueryItem(name: "page", value: "\(resource.pageNum)"))
                components.queryItems?.append(URLQueryItem(name: "with_genres", value: "\(resource.genreId)"))
                break
            case .searchMovie(let resource):
                components.path = "/3/search/\(resource.category)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                components.queryItems?.append(URLQueryItem(name: "include_adult", value: "true"))
                components.queryItems?.append(URLQueryItem(name: "page", value: "\(resource.pageNum)"))
                components.queryItems?.append(URLQueryItem(name: "query", value: "\(resource.query)"))
                break
            case .getAdditionalDetail(let id, let category):
            components.path = "/3/\(category.rawValue)/\(id)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getMovieVideos(let movieId, let category):
                components.path = "/3/\(category.rawValue)/\(movieId)/videos"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getCredits(let movieId,let category):
                components.path = "/3/\(category.rawValue)/\(movieId)/credits"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getRecommendations(let resource):
                components.path = "/3/\(resource.category)/\(resource.genreId)/similar"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                components.queryItems?.append(URLQueryItem(name: "page", value: "\(resource.pageNum)"))
                break
            case .getCastDetail(let id):
                components.path = "/3/person/\(id)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getPersonCredits(let id):
                components.path = "/3/person/\(id)/combined_credits"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getTrending(let window):
                components.path = "/3/trending/all/\(window.rawValue)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                break
            case .getList(let id):
            components.path = "/4/list/\(id.rawValue)"
                components.queryItems?.append(URLQueryItem(name: "language", value: "en-US"))
                components.queryItems?.append(URLQueryItem(name: "page", value: "\(1)"))
                break
        }
        print(components.url)
        return components.url
    }
    

    
    // this function will return the request for the API call, for POST calls the body or additional headers can be added here
    func asURLRequest() throws -> URLRequest {
        guard let url = findUrl() else {
            print("Couldnt find URL")
            throw URLError(URLError.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var parameters = Parameters()
        switch self {
        // since we only need to pass parameters for the POST call we have not specified the other cases
        case .validateWithLogin(let resource):
            parameters["username"] = resource.username
            parameters["password"] = resource.password
            parameters["request_token"] = resource.requestToken
            print(parameters)
            break
        default:
            break
        }
        
        // encoding the request with the encoding specified above if any
        request = try encoding.encode(request, with: parameters)
        return request
    }
    
    static func guestSession(onCompletion: @escaping (Any) -> Void){
        let jsonDecoder = JSONDecoder()
        AF.request(APIManager.createGuestSession).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                        let json = try? JSON(data: jsonData)
                        if let expires_at = json?["expires_at"].string{
                            let resource = try! jsonDecoder.decode(GuestSession.self, from: jsonData)
                            onCompletion(resource)
                            break
                        }
                        let resource = try! jsonDecoder.decode(ErrorResponse.self, from: jsonData)
                        onCompletion(resource)
                    }
                    break
                case .failure:
                    break
                default:
                    break
            }
        }
    }

    static func getRequestTokenMethod(username: String, password: String, onCompletion: @escaping (Any) -> Void) {
        AF.request(APIManager.getRequestToken)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { json in
            switch json.result{
                case .success:
                    let jsonDecoder = JSONDecoder()
                    if let jsonData = json.data {
                        let resource = try! jsonDecoder.decode(NewToken.self, from: jsonData)
                        let request = AF.request(APIManager.validateWithLogin(res:
                                                                Resource(username: username, password: password, requestToken: resource.request_token)))
                            .response { loginresponse in
                                switch loginresponse.result{
                                    case .success:
                                        if let data = loginresponse.data {
                                            print("data: ", data)
                                            print("response: ", loginresponse.response)
                                            print("request: ", loginresponse.request)
                                            print("description: ", loginresponse.description)
                                            print("error: ", loginresponse.error)
                                            print("httpMethod: ", loginresponse.request?.httpMethod)
                                            print("httpBody: ", "\(loginresponse.request?.httpBody)")
                                            let json = try? JSON(data: data)
                                            if let json = json{
                                                if let expires_at = json["expires_at"].string{
                                                    let resource = try! jsonDecoder.decode(UserAuth.self, from: data)
                                                    onCompletion(resource)
                                                    break
                                                }
                                            }else{
                                                onCompletion(false)
                                                break
                                            }
                                            let resource = try! jsonDecoder.decode(ErrorResponse.self, from: data)
                                            onCompletion(resource)
                                        }
                                        break;
                                    case .failure:
                                        let resource = try! jsonDecoder.decode(ErrorResponse.self, from: jsonData)
                                        onCompletion(resource)
                                        break
                                }
                        }
                            .responseJSON{ response in
                                let jsonString = String(data: response.data!, encoding: .utf8)!
                                print(jsonString)
                            }
                    }
                    break
                case .failure:
                    let jsonDecoder = JSONDecoder()
                    print("Unable to get request token")
                    if let jsonData = json.data {
                        let resource = try! jsonDecoder.decode(ErrorResponse.self, from: jsonData)
                        onCompletion(resource)
                    }
                    break
                }
            }
    }
    
    static func getAllGenre(category: GenreParent, onCompletion: @escaping (GenreResponse) -> Void){
        let jsonDecoder = JSONDecoder()
        AF.request(APIManager.getGenre(category: category)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                        let resource = try! jsonDecoder.decode(GenreResponse.self, from: jsonData)
                        onCompletion(resource)
                    }
                    break
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    static func getMovies(category: GenreParent, genreId: Int, pageNum: Int, onCompletion: @escaping (Any) -> Void){
        AF.request(APIManager.getGenreMovieList(resource:
                                                    URLResource(category: category.rawValue, genreId: genreId, query: "", pageNum: pageNum)))

            .responseJSON{ response in
            let jsonString = String(data: response.data!, encoding: .utf8)!
                switch(category){
                case .MOVIES:
                    let resource = MovieList(JSONString: jsonString)
                    onCompletion(resource)
                    break
                case .TV:
                    let resource = TvList(JSONString: jsonString)
                    onCompletion(resource)
                    break
                }
        }
    }
    
    static func searchMovies(category: GenreParent,query: String, pageNum: Int, onCompletion: @escaping (Any) -> Void){
        //let jsonDecoder = JSONDecoder()
        AF.request(APIManager.searchMovie(resource:
                                            URLResource(category: category.rawValue, genreId: 0, query: query, pageNum: pageNum)))
           
        .responseJSON{ response in
            let jsonString = String(data: response.data!, encoding: .utf8)!
            switch(category){
            case .MOVIES:
                let resource = MovieList(JSONString: jsonString)
                onCompletion(resource)
                break
            case .TV:
                let resource = TvList(JSONString: jsonString)
                onCompletion(resource)
                break
            }
        }
    }
    
    static func getAddiDetail(movieId: Int, category: GenreParent, onCompletion: @escaping (Any) -> Void){
        let jsonDecoder = JSONDecoder()
        AF.request(APIManager.getAdditionalDetail(id: movieId, category: category)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                        let json = try? JSON(data: jsonData)
                        switch category {
                        case .MOVIES:
                            let resource = try! jsonDecoder.decode(MovieAdditionalDetails.self, from: jsonData)
                            onCompletion(resource)
                            break
                        case .TV:
                            let resource = try! jsonDecoder.decode(TVAdditionalDetail.self, from: jsonData)
                            onCompletion(resource)
                            break
                        }
                    }
                    break
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getMovieVideos(category: GenreParent, movieId: Int, onCompletion: @escaping (Any) -> Void){
        let jsonDecoder = JSONDecoder()
        AF.request(APIManager.getMovieVideos(movieId: movieId, category: category)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                        switch category {
                        case .MOVIES:
                            let resource = try! jsonDecoder.decode(MovieVideo.self, from: jsonData)
                            onCompletion(resource)
                            break
                        case .TV:
                            let resource = try! jsonDecoder.decode(MovieVideo.self, from: jsonData)
                            onCompletion(resource)
                            break
                        }
                    }
                    break
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getCredits(category: GenreParent, movieId: Int, onCompletion: @escaping (Cast) -> Void){
        let jsonDecoder = JSONDecoder()
        AF.request(APIManager.getCredits(movieId: movieId, category: category)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                            let resource = try! jsonDecoder.decode(Cast.self, from: jsonData)
                            onCompletion(resource)
                        }
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getRecommended(category: GenreParent, movieId: Int, pageNum: Int, onCompletion: @escaping (Any) -> Void){
        AF.request(APIManager.getRecommendations(resource:
                                                    URLResource(category: category.rawValue,
                                                                genreId: movieId,
                                                                query: "",
                                                                pageNum: pageNum))).responseJSON{ response in
            let jsonString = String(data: response.data!, encoding: .utf8)!
                switch(category){
                case .MOVIES:
                    let resource = MovieList(JSONString: jsonString)
                    onCompletion(resource)
                    break
                case .TV:
                    let resource = TvList(JSONString: jsonString)
                    onCompletion(resource)
                    break
                }
        }
    }
    
    static func getPersonDetail(id: Int, onCompletion: @escaping (Any) -> Void){
        AF.request(APIManager.getCastDetail(id: id)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                            let jsonDecoder = JSONDecoder()
                            let resource = try! jsonDecoder.decode(PeopleDetail.self, from: jsonData)
                            onCompletion(resource)
                        }
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getPersonCombCredits(id: Int, onCompletion: @escaping (Any) -> Void){
        AF.request(APIManager.getPersonCredits(id: id)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                            let jsonDecoder = JSONDecoder()
                            let resource = try! jsonDecoder.decode(Credits.self, from: jsonData)
                            onCompletion(resource)
                        }
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getTrending(window: Time_Window, onCompletion: @escaping (Any) -> Void){
        AF.request(APIManager.getTrending(window: window)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                            let jsonDecoder = JSONDecoder()
                            let resource = try! jsonDecoder.decode(TrendingResults.self, from: jsonData)
                            onCompletion(resource)
                        }
                case .failure:
                    break
                default:
                    break
            }
        }
    }
    
    static func getMyList(id: ListId, onCompletion: @escaping (ListResult) -> Void){
        AF.request(APIManager.getList(id: id)).response { json in
            switch json.result{
                case .success:
                    if let jsonData = json.data {
                            let jsonDecoder = JSONDecoder()
                            let resource = try! jsonDecoder.decode(ListResult.self, from: jsonData)
                            onCompletion(resource)
                        }
                case .failure:
                    break
                default:
                    break
            }
        }
    }

}
