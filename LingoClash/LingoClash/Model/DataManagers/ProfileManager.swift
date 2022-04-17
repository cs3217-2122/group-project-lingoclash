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

        super.init(resource: DataManagerResources.profiles)
    }

    func getCurrentProfileData() -> Promise<ProfileData> {
        firstly {
            authProvider.getIdentity()
        }.then { userIdentity in
            self.getManyReference(target: "user_id", id: userIdentity.id ?? "-1")
        }.compactMap { profilesData in
            guard !profilesData.isEmpty else {
                return nil
            }

            return profilesData[0]
        }
    }

    func getCurrentProfile() -> Promise<Profile> {
        let currentProfileData = self.getCurrentProfileData()
        return buildNestedProfile(profileData: currentProfileData)
    }

    func getProfile(id: Identifier) -> Promise<Profile> {
        let profileData = self.getOne(id: id)
        return buildNestedProfile(profileData: profileData)
    }

    func setAsCurrentBook(bookId: Identifier) -> Promise<ProfileData> {

        firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            var newProfileData = profileData
            newProfileData.book_id = bookId

            return self.update(id: profileData.id, to: newProfileData)
        }
    }

    func updateProfile(starsGoal: Int, bio: String) -> Promise<ProfileData> {
        firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            var newProfileData = profileData
            newProfileData.stars_goal = starsGoal
            newProfileData.bio = bio

            return self.update(id: profileData.id, to: newProfileData)
        }
    }

    func updateProfile(stars: Int, vocabsLearnt: Int) -> Promise<ProfileData> {

        firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            var newProfileData = profileData
            newProfileData.stars = stars
            newProfileData.vocabs_learnt = vocabsLearnt

            return self.update(id: profileData.id, to: newProfileData)
        }
    }

    func createProfile(params: SignUpFields, userId: Identifier) -> Promise<Profile> {
        let profileData = ProfileData(userId: userId, name: params.name, email: params.email)
        var profile: Profile?

        return firstly {
            self.create(newRecord: profileData)
        }.then { _ in
            self.getCurrentProfile()
        }.done { currProfile in
            profile = currProfile
            let starAccountData = StarAccountData(ownerId: currProfile.id)
            StarAccountManager().create(newRecord: starAccountData).catch { error in
                print(error)
            }
        }.compactMap {
            guard let profile = profile else {
                return nil
            }
            return profile
        }
    }

    func incrementVocabsLearnt(by increment: Int) {
        _ = firstly {
            self.getCurrentProfileData()
        }.then { profileData -> Promise<ProfileData> in
            var newProfileData = profileData
            newProfileData.vocabs_learnt = profileData.vocabs_learnt + increment

            return self.update(id: profileData.id, to: newProfileData)
        }
    }

    private func buildNestedProfile(
        profileData: Promise<ProfileData>) -> Promise<Profile> {
        var profile: ProfileData?
        var currentBook: Book?
        var rankingByTotalStars: Int?
        var winningPKRate: Double?

        return profileData.then { profileData-> Promise<Void> in
            // Gets the current book
            profile = profileData
            guard let currentBookId = profileData.book_id else {
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
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }

            return firstly {
                self.getList()
            }.done { profiles in
                let sortedProfiles = profiles.sorted(by: { (p1: ProfileData, p2: ProfileData) -> Bool in
                    p1.stars < p2.stars
                })

                rankingByTotalStars = sortedProfiles.firstIndex {
                    $0.id == profile.id
                }

                rankingByTotalStars? += 1

            }
        }.then { () -> Promise<Void> in
            // Gets the pk winning rate
            guard let profile = profile else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }

            return firstly { () -> Promise<[PKGamePlayerOutcomeData]> in
                // 1. get the list of player outcomes whose profile_id = profile.id
                let filters: [String: Any] = [
                    "profile_id": profile.id
                ]
                return PKGamePlayerOutcomeManager().getList(filter: filters)
            }.done { playerOutcomes in
                var uniquePlayerOutcomes = Set<PKGamePlayerOutcomeData>()
                for outcome in playerOutcomes {
                    uniquePlayerOutcomes.insert(outcome)
                }

                let wins = uniquePlayerOutcomes.filter { $0.outcome == .win }.count
                let total = uniquePlayerOutcomes.count
                winningPKRate = Double(wins) / Double(total) * 100
            }
        }.compactMap {
            guard let profile = profile,
                    let rankingByTotalStars = rankingByTotalStars,
                    let winningPKRate = winningPKRate else {
                return nil
            }

            return Profile(
                profileData: profile,
                currentBook: currentBook,
                rankingByTotalStars: rankingByTotalStars, pkWinningRate: winningPKRate)
        }
    }
}
