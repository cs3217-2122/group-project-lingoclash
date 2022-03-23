//
//  ProfileViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import PromiseKit
import Combine

final class ProfileViewModel {
    
    @Published var error: String?
    @Published var name: String?
    @Published var email: String?
    @Published var totalStars: Int?
    @Published var starsToday: Int?
    @Published var alertContent: AlertContent?
    
    private let authProvider: AuthProvider
    private let userDataManager = UserDataManager()
    private let profileDataManager = ProfileDataManager()
    private let profileBookDataManager = ProfileDataManager()
    
    var firstName: String?
    var lastName: String?
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
    }
    
    func signOut() {
        firstly {
            authProvider.logout()
        }.done {
            self.error = nil
            self.alertContent = AlertContent(title: "", message: "Are you sure you want to log out?", type: .confirm)
        }.catch { error in
            self.error = error.localizedDescription
        }
    }
    
    func refreshProfile() {
        var authUser: UserIdentity?
        firstly {
            authProvider.getIdentity()
        }.done { userIdentity in
            self.error = nil
            authUser = userIdentity
        }.catch { error in
            self.error = error.localizedDescription
        }
        
        guard let authUser = authUser else {
            return
        }
        
//        let user = userDataManager.getOne(id: "aNcV0rwqWcGpF45wTDUU")
        let user = userDataManager.getManyReference(target: "uid", id: authUser.id ?? "1")
        user.done { users in
            let user = users[0]
            self.firstName = user.first_name
            self.lastName = user.last_name
            self.name = user.first_name + " " + user.last_name
            self.email = authUser.email
            
            let profile = self.profileDataManager.getOne(id: user.profile_id)
            profile.done { profile in
                self.totalStars = profile.stars
                self.starsToday = profile.stars_today
            }.catch { error in
                self.error = error.localizedDescription
            }
            
        }.catch { error in
            self.error = error.localizedDescription
        }
    }
    
    func editProfile(firstName: String, lastName: String) {
        // TODO: edit profile
    }
    
    func changeEmail(newEmail: String, confirmNewEmail: String) {
        // TODO: change email
    }
    
    func changePassword(currentPassword: String, newPassword: String, confirmNewPassword: String) {
        // TODO: change password
    }
}
