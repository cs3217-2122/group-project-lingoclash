//
//  HomeViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 8/4/22.
//
// 
// import PromiseKit
// import Combine
// import FirebaseFirestore
// import FirebaseAuth

// class HomeViewModel {
//     var profile: Profile?
//     var pkGameLobbyViewModel: PKGameLobbyViewModel?
//     let authProvider: AuthProvider
//     init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
//         self.authProvider = authProvider
//         self.refreshProfile()
//     }
    
//     func refreshProfile() {
//        guard let authUser = Auth.auth().currentUser else {
//            return
//        }
        // TODO: get profile from firebase from current logged in user, now: generates same profile but with random profile_id
        // let profile = Profile(user_id: "user1", currentBookId: "book1", email: "awdawd", name: "player1", stars: 0, stars_today: 0)
        // self.profile = profile
        // self.pkGameLobbyViewModel = PKGameLobbyViewModelFromProfile(playerProfile: profile)
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
//     }
// }


import Combine
import PromiseKit

class HomeViewModel {
    @Published var isRefreshing = false
    @Published var profile: Profile?
    @Published var currentBook: Book?
    @Published var lessonSelectionViewModel: LessonSelectionViewModel?
    @Published var pkGameLobbyViewModel: PKGameLobbyViewModel?

    
    private let profileManager = ProfileManager()
    
    func refresh() {
        self.isRefreshing = true
        firstly {
            profileManager.getCurrentProfile()
        }.done { profile in
            self.profile = profile
            self.currentBook = profile.currentBook

            if let book = profile.currentBook {
                self.lessonSelectionViewModel = LessonSelectionViewModelFromBook(book: book)
            }
            self.pkGameLobbyViewModel = PKGameLobbyViewModelFromProfile(playerProfile: profile)

            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
}

