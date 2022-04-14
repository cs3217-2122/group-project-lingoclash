//
//  Profile.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileData {
    var id: Identifier
    let book_id: Identifier?
    let user_id: Identifier
    let stars: Int
    let stars_today: Int
    let stars_goal: Int
    let bio: String
    let days_learning: Int
    let vocabs_learnt: Int
    let pk_winning_rate: Double
}

extension ProfileData: Record {}
