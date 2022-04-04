//
//  Profile.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct Profile {
    var id: Identifier
    let currentBook: Book?
    let stars: Int
    let starsToday: Int
    
    init(profileData: ProfileData, currentBook: Book?) {
        self.id = profileData.id
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.currentBook = currentBook
    }
}
