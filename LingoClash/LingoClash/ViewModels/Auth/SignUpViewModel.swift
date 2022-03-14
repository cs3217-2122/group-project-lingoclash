//
//  SignUpViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel {
    
    @Published var error: String?
    
    func signUp(firstName: String, lastName: String, email: String, password: String) {
        
        let fields = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        
        // Validate fields
        let error = validateFields(fields)
        if let error = error {
            self.error = error
            return
        }
        
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if error != nil {
                self?.error = "Error creating user."
            } else {
                guard let result = result else {
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid":result.user.uid]) { error in
                    self?.error = (error != nil)
                    ? "Error saving user data."
                    : nil
                }
            }
        }
    }
    
    ///  Returns: nil if fields are correct, else return error message
    func validateFields(_ fields: [String: String]) -> String? {
        // Check that all fields are filled in
        if fields.values.contains("") {
            return "Please fill in all fields."
        }
        
        // Check that email format is valid
        if let email = fields["email"] {
            return validateEmail(email: email)
        }
        
        if let password = fields["password"] {
            return validatePassword(password: password)
        }
        
        
        return nil
    }
    
    private func validateEmail(email: String) -> String? {
        if Utilities.isEmailValid(email) == false {
            return "Please input a valid email."
        }
        return nil
    }
    
    private func validatePassword(password: String) -> String? {
        if Utilities.isPasswordValid(password) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
}
