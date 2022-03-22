//
//  ProfileViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
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
        // TODO: get user profile
        self.firstName = "John"
        self.lastName = "Doe"
        self.name = "John Doe"
        self.email = "guy@gmail.com"
        self.totalStars = 5
        self.starsToday = 1
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
