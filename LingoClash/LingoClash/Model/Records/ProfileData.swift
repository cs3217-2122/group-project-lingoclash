//
//  Profile.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileData {
    var id: Identifier
    var book_id: Identifier?
    var user_id: Identifier
    var name: String
    var email: String
    var stars: Int
    var stars_today: Int
    var stars_goal: Int
    var bio: String
    var days_learning: Int
    var vocabs_learnt: Int
    var pk_winning_rate: Double
}

extension ProfileData: Record {}
