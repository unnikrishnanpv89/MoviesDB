//
//  UserLoggedIn.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/22.
//
import Foundation
import RealmSwift

class UserLoggedIn: Object {
    @objc dynamic var userName : String?
    @objc dynamic var isLoggedIn = false
    @objc dynamic var requestToken: String?
    @objc dynamic var expireAt: String?
    @objc dynamic var faceIDAuth = false
    
    static func create(username: String, requestToken: String, expiresAt: String) -> UserLoggedIn {
        let userLoggedIn = UserLoggedIn()
        userLoggedIn.isLoggedIn = true
        userLoggedIn.userName = username
        userLoggedIn.expireAt = expiresAt
        userLoggedIn.requestToken = requestToken
        return userLoggedIn
    }
    
    override class func primaryKey() -> String? {
            return "userName"
    }
}
