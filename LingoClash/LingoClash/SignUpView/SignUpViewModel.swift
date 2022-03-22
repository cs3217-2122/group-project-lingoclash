//
//  SignUpViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

final class SignUpViewModel {
    
    @Published var error: String?
    
    private let authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
    }
    
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
        
        firstly {
            authProvider.register(params: fields)
        }.done {
            self.error = nil
        }.catch { error in
            self.error = error.localizedDescription
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
