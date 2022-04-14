//
//  Profile.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct Profile {
    var id: Identifier
    let name: String
    let email: String
    let currentBook: Book?
    let stars: Int
    let starsToday: Int
    let starsGoal: Int
    let bio: String
    let daysLearning: Int
    let vocabsLearnt: Int
    let pkWinningRate: Double
    let rankingByTotalStars: Int

    init(userIdentity: UserIdentity, profileData: ProfileData, currentBook: Book?, rankingByTotalStars: Int) {
        self.id = profileData.id
        self.name = userIdentity.fullName ?? ""
        self.email = userIdentity.email ?? ""
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.currentBook = currentBook
        self.starsGoal = profileData.stars_goal
        self.bio = profileData.bio
        self.daysLearning = profileData.days_learning
        self.vocabsLearnt = profileData.vocabs_learnt
        self.pkWinningRate = profileData.pk_winning_rate
        self.rankingByTotalStars = rankingByTotalStars
    }
}
