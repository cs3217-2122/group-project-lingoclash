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
    
    init(userIdentity: UserIdentity, profileData: ProfileData, currentBook: Book?) {
        self.id = profileData.id
        self.name = userIdentity.fullName ?? ""
        self.email = userIdentity.email ?? ""
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.currentBook = currentBook
    }
}
