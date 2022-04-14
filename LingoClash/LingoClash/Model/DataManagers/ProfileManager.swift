//
//  ProfileDataManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

import PromiseKit
import Foundation

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
        var rankingByTotalStars: Int?
        
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
        }.then { () -> Promise<Void> in
            // Gets the ranking of the profile by total stars
            guard let profile = profile else {
                return Promise<Void>.resolve(value: ())
            }
            
            return firstly {
                self.getList()
            }.done { profiles in
                let sortedProfiles = profiles.sorted(by: { (p1: ProfileData, p2: ProfileData) -> Bool in
                    return p1.stars < p2.stars
                })
                
                rankingByTotalStars = sortedProfiles.firstIndex {
                    $0.id == profile.id
                }
                
                rankingByTotalStars? += 1
                
            }
        }.compactMap {
            guard let profile = profile, let currentUser = currentUser, let rankingByTotalStars = rankingByTotalStars else {
                return nil
            }
            
            return Profile(
                userIdentity: currentUser,
                profileData: profile,
                currentBook: currentBook,
                rankingByTotalStars: rankingByTotalStars)
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
                stars: profileData.stars,
                stars_today: profileData.stars_today,
                stars_goal: profileData.stars_goal,
                bio: profileData.bio,
                days_learning: profileData.days_learning,
                vocabs_learnt: profileData.vocabs_learnt,
                pk_winning_rate: profileData.pk_winning_rate
            )
            
            return self.update(id: profileData.id, from: profileData, to: newProfileData)
        }
    }
    
    func updateProfile(starsGoal: Int, bio: String) -> Promise<ProfileData> {
        
        return firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            let newProfileData = ProfileData(
                id: profileData.id,
                book_id: profileData.book_id,
                user_id: profileData.user_id,
                stars: profileData.stars,
                stars_today: profileData.stars_today,
                stars_goal: starsGoal,
                bio: bio,
                days_learning: profileData.days_learning,
                vocabs_learnt: profileData.vocabs_learnt,
                pk_winning_rate: profileData.pk_winning_rate
            )
            
            return self.update(id: profileData.id, from: profileData, to: newProfileData)
        }
    }
    
}
