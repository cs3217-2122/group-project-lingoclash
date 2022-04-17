//
//  SettingsViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 13/4/22.
//

import Foundation
import PromiseKit

final class SettingsViewModel {
    
    @Published var isRefreshing = false
    @Published var name: String?
    @Published var starsGoal: Int?
    @Published var bio: String?
    @Published var email: String?
    @Published var totalStars: Int?
    @Published var starsToday: Int?
    @Published var editProfileError: String?
    @Published var changeEmailError: String?
    @Published var changePasswordError: String?
    @Published var error: String?
    @Published var alertContent: AlertContent?
    @Published var isLightSelected = UserDefaults.standard.bool(forKey: "LightTheme")
    
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
        if self.isRefreshing {
            return
        }
        
        self.isRefreshing = true
        firstly {
            profileManager.getCurrentProfile()
        }.done { profile in
            self.name = profile.name
            self.starsGoal = profile.starsGoal
            self.bio = profile.bio
            self.email = profile.email
            self.starsToday = profile.starsToday
            self.totalStars = profile.stars
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
    
    func stopRefresh() {
        self.isRefreshing = false
    }
    
    func editProfile(_ fields: EditProfileFields) {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            editProfileError = error
            return
        }
        
        if name == fields.name, starsGoal == fields.starsGoal, bio == fields.bio {
            return
        }
        
        firstly {
            authProvider.updateName(fields.name)
        }.then { [self] _ in
            self.profileManager.updateProfile(
                starsGoal: fields.starsGoal ,
                bio: fields.bio)
        }.done { [self] _ in
            self.editProfileError = nil
            self.alertContent = AlertContent(title: "", message: "Your profile is updated succesfully.")
            self.refresh()
        }.catch { [self] error in
            self.editProfileError = error.localizedDescription
        }
    }
    
    func changeEmail(_ fields: ChangeEmailFields) {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            changeEmailError = error
            return
        }
        
        if let error = FormUtilities.validateEmail(email: fields.newEmail) {
            changeEmailError = error
            return
        }
        
        if email == fields.newEmail {
            changeEmailError = "New email must be different from the current email."
            return
        }
        
        firstly {
            authProvider.updateEmail(fields.newEmail)
        }.done {
            self.changeEmailError = nil
            self.alertContent = AlertContent(title: "", message: "Your email is updated succesfully.")
            self.refresh()
        }.catch { error in
            self.changeEmailError = error.localizedDescription
        }
    }
    
    func changePassword(_ fields: ChangePasswordFields) {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            changePasswordError = error
            return
        }
        
        if let error = FormUtilities.validatePassword(password: fields.newPassword) {
            changePasswordError = error
            return
        }
        
        if fields.newPassword != fields.confirmNewPassword {
            changePasswordError = "New password and confirmation password must be the same."
            return
        }
        
        if fields.newPassword == fields.currentPassword {
            changePasswordError = "New password must be different from the current password."
            return
        }
        
        firstly {
            authProvider.reauthenticate(password: fields.currentPassword)
        }.then {
            self.authProvider.updatePassword(fields.newPassword)
        }.done {
            self.error = nil
            self.alertContent = AlertContent(title: "", message: "Your password is updated succesfully.")
            self.refresh()
        }.catch { error in
            self.changePasswordError = error.localizedDescription
        }
    }
    
    func setTheme(selectedTheme: Int) {
        self.isLightSelected = selectedTheme == 0
    }
    
}
