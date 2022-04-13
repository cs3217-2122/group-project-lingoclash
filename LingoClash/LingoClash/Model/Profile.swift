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
    // let currentBookId: Identifier
    let currentBook: Book?
    let email: String
    let name: String
    let stars: Int
    let starsToday: Int
    init(userIdentity: UserIdentity, profileData: ProfileData, currentBook: Book?) {
        self.id = profileData.id
        self.name = userIdentity.fullName ?? ""
        self.email = userIdentity.email ?? ""
        self.user_id = profileData.user_id
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.currentBook = currentBook
    }
    
    init(profileData: ProfileData, currentBook: Book?) {
        self.id = profileData.id
        self.name = profileData.name
        self.email = profileData.email
        self.user_id = profileData.user_id
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
        self.currentBook = currentBook
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

//extension Profile: Codable, Hashable {}
