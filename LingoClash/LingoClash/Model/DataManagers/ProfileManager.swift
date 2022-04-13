//
//  ProfileDataManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

import PromiseKit

class ProfileManager: DataManager<ProfileData> {
    
    private var authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
        
        super.init(resource: "profiles")
    }
    
    func getCurrentProfileData() -> Promise<ProfileData> {
        return firstly {
            authProvider.getIdentity()
        }.then { userIdentity in
            // Gets the profile
            self.getManyReference(target: "user_id", id: userIdentity.id ?? "-1")
        }.compactMap { profilesData in
            guard !profilesData.isEmpty else {
                return nil
            }
            
            return profilesData[0]
        }
    }
    
    func getCurrentProfile() -> Promise<Profile> {
        var profile: ProfileData?
        var currentBook: Book?
        var currentUser: UserIdentity?
        
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
                currentUser = userIdentity
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
            guard let profile = profile, let currentUser = currentUser else {
                return nil
            }
            
            return Profile(userIdentity: currentUser, profileData: profile, currentBook: currentBook)
        }
    }
    
    func getProfile(id: Identifier) -> Promise<Profile> {
        // TODO: Refactor getCurrentProfile to use this to avoid DRY
        var profile: ProfileData?
        var currentBook: Book?
        var currentUser: UserIdentity?
        
        return firstly {
            firstly {
                self.getOne(id: id)
            }.done {
                profile = $0
            }
        }.then { () -> Promise<Void> in
            guard let profile = profile else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }
            // Gets the current book
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
    
    func setAsCurrentBook(bookId: Identifier) -> Promise<ProfileData> {
        
        return firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            let newProfileData = ProfileData(
                id: profileData.id,
                book_id: bookId,
                user_id: profileData.user_id,
                name: profileData.name,
                email: profileData.email,
                stars: profileData.stars,
                stars_today: profileData.stars_today)
            
            return self.update(id: profileData.id, from: profileData, to: newProfileData)
        }
    }
    
}
