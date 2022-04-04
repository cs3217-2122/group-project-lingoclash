//
//  ProfileDataManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

import PromiseKit

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

class ProfileManager: DataManager<ProfileData> {
    
    private var authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
        
        super.init(resource: "profiles")
    }
    
    func getCurrentProfile() -> Promise<Profile> {
        var profile: ProfileData?
        var currentBook: Book?
        
        return firstly {
            authProvider.getIdentity()
        }.then { userIdentity -> Promise<Void> in
            // Gets the profile
            return firstly {
                self.getManyReference(target: "user_id", id: userIdentity.id ?? "-1")
            }.done { profilesData in
                guard !profilesData.isEmpty else {
                    return
                }
                
                profile = profilesData[0]
            }
        }.then { () -> Promise<Void> in
            // Gets the current book
            guard let profile = profile else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }
            
            guard let currentBookId = profile.book_id else {
                return Promise<Void>.resolve(value: ())
            }

            return firstly {
                BookManager().getBook(id: currentBookId)
            }.done { book in
                currentBook = book
            }
        }.compactMap {
            guard let profile = profile else {
                return nil
            }

            return Profile(profileData: profile, currentBook: currentBook)
        }
    }
    
}
