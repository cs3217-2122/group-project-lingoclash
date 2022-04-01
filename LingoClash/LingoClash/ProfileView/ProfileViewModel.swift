//
//  ProfileViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import PromiseKit
import Combine
import FirebaseFirestore
import FirebaseAuth

final class ProfileViewModel {
    
    @Published var error: String?
    @Published var editProfileError: String?
    @Published var changeEmailError: String?
    @Published var changePasswordError: String?
    @Published var name: String?
    @Published var email: String?
    @Published var totalStars: Int?
    @Published var starsToday: Int?
    @Published var alertContent: AlertContent?
    
    private let authProvider: AuthProvider
    private let profileDataManager = ProfileDataManager()
    private let profileBookDataManager = ProfileDataManager()
    private let db = Firestore.firestore()
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
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
    
    func refreshProfile() {
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        db.collection("profiles").whereField("user_id", isEqualTo: authUser.uid).getDocuments { querySnapshot, err in
            if let _ = err {
                return
            }
            
            guard let data = querySnapshot?.documents[0] else {
                return
            }
            
            self.name = authUser.displayName
            self.email = authUser.email
            
            if let starsToday = data["stars_today"] as? Int {
                self.starsToday = starsToday
            }
            
            if let stars = data["stars"] as? Int {
                self.totalStars = stars
            }
        }
    }
    
    func editProfile(_ fields: EditProfileFields) {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            editProfileError = error
            return
        }
        
        if name == fields.name {
            return
        }
        
        firstly {
            authProvider.updateName(fields.name)
        }.done {
            self.editProfileError = nil
            self.alertContent = AlertContent(title: "", message: "Your name is updated succesfully.")
            self.refreshProfile()
        }.catch { error in
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
            self.refreshProfile()
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
            self.refreshProfile()
        }.catch { error in
            self.changePasswordError = error.localizedDescription
        }
    }
}
