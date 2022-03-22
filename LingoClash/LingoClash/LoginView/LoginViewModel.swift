//
//  LoginViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

final class LoginViewModel {
    
    @Published var error: String?
    
    private let authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
    }
    
    func login(email: String, password: String) {
        
        let fields = [
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
            authProvider.login(params: fields)
        }.done {
            self.error = nil
        }.catch { error in
            self.error = error.localizedDescription
        }
    }
    
    ///  Returns: nil if fields are correct, else return error message
    func validateFields(_ fields: [String:String]) -> String? {
        // Check that all fields are filled in
        if fields.values.contains("") {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
}
