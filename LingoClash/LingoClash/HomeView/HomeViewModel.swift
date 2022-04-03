//
//  HomeViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

import PromiseKit
import Combine
import FirebaseFirestore
import FirebaseAuth

class HomeViewModel {
    var profile: Profile?
    var pkGameLobbyViewModel: PKGameLobbyViewModel?
    let authProvider: AuthProvider
    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
        self.authProvider = authProvider
        self.refreshProfile()
    }
    
    func refreshProfile() {
//        guard let authUser = Auth.auth().currentUser else {
//            return
//        }
        // TODO: get profile from firebase from current logged in user, now: generates same profile but with random profile_id
        let profile = Profile(user_id: "user1", currentBookId: "book1", email: "awdawd", name: "player1", stars: 0, stars_today: 0)
        self.profile = profile
        self.pkGameLobbyViewModel = PKGameLobbyViewModelFromProfile(playerProfile: profile)
//        db.collection("profiles").whereField("user_id", isEqualTo: authUser.uid).getDocuments { querySnapshot, err in
//            if let _ = err {
//                return
//            }
//
//            guard let data = querySnapshot?.documents[0] else {
//                return
//            }
//
//            self.profile =
//
//            if let starsToday = data["stars_today"] as? Int {
//                self.starsToday = starsToday
//            }
//
//            if let stars = data["stars"] as? Int {
//                self.totalStars = stars
//            }
//        }
    }
}
