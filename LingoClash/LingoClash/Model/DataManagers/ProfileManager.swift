//
//  ProfileDataManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

import PromiseKit


// fetch too many things; ...
struct Profile {
    var id: Identifier
//    let currentBook: Book
    let stars: Int
    let starsToday: Int
    
    init(profileData: ProfileData) {
        self.id = profileData.id
        self.stars = profileData.stars
        self.starsToday = profileData.stars_today
    }
}

class ProfileManager: DataManager<ProfileData> {
    
    private var authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
        
        super.init(resource: "profiles")
    }
    
//    func getCurrentProfile() -> Promise<Profile> {
//        // TODO: HACKY
//        var profileData: ProfileData?
//        
//        firstly {
//            authProvider.getIdentity()
//        }.then { result in
//            self.getManyReference(target: "user_id", id: result.id ?? "-1")
//        }.compactMap { profiles in
//            guard !profiles.isEmpty else {
//                return nil
//            }
//            profileData = profiles[0]
//            return profileData
//        }.then { profileDataResult -> Promise<Book?> in
//            guard let bookId = profileDataResult.book_id else {
//                return Promise.resolve(value: nil)
//            }
//            let bookManager = BookManager()
//            // chnage to get book; get full book
//            return bookManager.getOne(id: profileDataResult.book_id)
//        }.map { bookData in
//            
//            
//        }
//    }
    
}
