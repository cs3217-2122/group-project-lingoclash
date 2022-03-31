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
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var email: String?
    @Published var totalStars: Int?
    @Published var starsToday: Int?
    @Published var alertContent: AlertContent?
    
    private let authProvider: AuthProvider
    private let userDataManager = UserDataManager()
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
        
        
        db.collection("users").whereField("uid", isEqualTo: authUser.uid).getDocuments { querySnapshot, err in
            if let _ = err {
                return
            }
            
            guard let data = querySnapshot?.documents[0] else {
                return
            }
            
            if let firstName = data["first_name"] as? String {
                self.firstName = firstName
            }
            
            if let lastName = data["last_name"] as? String {
                self.lastName = lastName
            }
            
            self.email = authUser.email
            
            self.db.collection("profiles").whereField("user_id", isEqualTo: data.documentID).getDocuments { querySnapshot, err in
                if let _ = err {
                    return
                }
                
                guard let document = querySnapshot?.documents[0] else {
                    return
                }
                
                if let starsToday = document["stars_today"] as? Int {
                    self.starsToday = starsToday
                }
                
                if let stars = document["stars"] as? Int {
                    self.totalStars = stars
                }
            }
        }
    }
    
    func editProfile(_ fields: EditProfileFields) {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            editProfileError = error
            return
        }
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        db.collection("users").whereField("uid", isEqualTo: authUser.uid).getDocuments { querySnapshot, err in
            if let _ = err {
                return
            }
            
            guard let document = querySnapshot?.documents[0] else {
                return
            }
            
            self.db.collection("users").document(document.documentID).updateData([
                "first_name": fields.firstName,
                "last_name": fields.lastName
            ]) { err in
                if let _ = err {
                    self.editProfileError = "Error updating profile."
                } else {
                    self.editProfileError = nil
                    self.alertContent = AlertContent(title: "", message: "Your profile is updated succesfully.")
                    self.refreshProfile()
                }
            }
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
