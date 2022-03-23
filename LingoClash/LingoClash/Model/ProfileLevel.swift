//
//  ProfileLevel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileLevel {
    var id: Identifier
    let level_id: Identifier
    let stars: Int
}

extension ProfileLevel: Codable {}
