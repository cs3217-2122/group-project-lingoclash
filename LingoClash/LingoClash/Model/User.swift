//
//  User.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct User {
    var id: Identifier
    let profile_id: Identifier
    let first_name: String
    let last_name: String
}

extension User: Codable {}
