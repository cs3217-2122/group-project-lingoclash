//
//  ProfileViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import PromiseKit
import Combine

final class ProfileViewModel {

    @Published var isRefreshing = false
    @Published var error: String?
    @Published var name: String?
    @Published var email: String?
    @Published var totalStars: Int?
    @Published var starsToday: Int?
    @Published var starsGoal: Int?
    @Published var starsGoalProgress: Float?
    @Published var bio: String?
    @Published var daysLearning: Int?
    @Published var vocabsLearnt: Int?
    @Published var pkWinningRate: Double?
    @Published var rankingByTotalStars: Int?
    @Published var alertContent: AlertContent?

    private let authProvider: AuthProvider
    private let profileManager = ProfileManager()

    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
        self.authProvider = authProvider
    }

    func signOut() {
        firstly {
            authProvider.logout()
        }.done {
            self.error = nil
            self.alertContent = AlertContent(title: "", message: "Are you sure you want to log out?")
        }.catch { error in
            self.error = error.localizedDescription
        }
    }

    func refresh() {
        self.isRefreshing = true
        firstly {
            profileManager.getCurrentProfile()
        }.done { profile in
            self.name = profile.name
            self.email = profile.email
            self.starsToday = profile.starsToday
            self.totalStars = profile.stars
            self.starsGoal = profile.starsGoal
            self.starsGoalProgress = min(
                Float(profile.starsToday / profile.starsGoal), 1)
            self.bio = profile.bio
            self.daysLearning = profile.daysLearning
            self.vocabsLearnt = profile.vocabsLearnt
            self.pkWinningRate = profile.pkWinningRate
            self.rankingByTotalStars = profile.rankingByTotalStars
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }

}
