//
//  AuthProviderTypes.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

struct UserCredentials: Codable {
    let email: String
    let password: String
}

struct LoginResult: Codable {
    let access_token: String
}
