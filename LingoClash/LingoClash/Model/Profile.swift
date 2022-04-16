//
//  Profile.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct Profile {
    var id: Identifier
    let user_id: Identifier
    let currentBook: Book?
    let email: String
    let name: String
    let stars: Int
    let starsToday: Int
    let starsGoal: Int
    let bio: String
    let daysLearning: Int
    let vocabsLearnt: Int
    let pkWinningRate: Double
    let rankingByTotalStars: Int

    init(profileData: ProfileData, currentBook: Book?, rankingByTotalStars: Int, pkWinningRate: Double) {
        self.id = profileData.id
        self.user_id = profileData.user_id
        self.currentBook = currentBook
        self.email = profileData.email
        self.name = profileData.name
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.starsGoal = profileData.stars_goal
        self.bio = profileData.bio
        self.daysLearning = profileData.days_learning
        self.vocabsLearnt = profileData.vocabs_learnt
        self.pkWinningRate = pkWinningRate
        self.rankingByTotalStars = rankingByTotalStars
    }
}

extension Profile: Hashable {
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// extension Profile: Codable, Hashable {}
