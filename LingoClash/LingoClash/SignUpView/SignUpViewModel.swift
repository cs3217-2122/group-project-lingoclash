//
//  SignUpViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit
import FirebaseFirestore

final class SignUpViewModel {
    
    @Published var error: String?
    
    private let authProvider: AuthProvider
    
    init(authProvider: AuthProvider = FirebaseAuthProvider()) {
        self.authProvider = authProvider
    }
    
    func signUp(_ fields: SignUpFields) {
        let error = validateFields(fields)
        if let error = error {
            self.error = error
            return
        }
        
        firstly {
            authProvider.register(params: fields)
        }.then { result -> Promise<Void> in
            return Promise { seal in
                let db = Firestore.firestore()
                db.collection("profiles").addDocument(
                    data: [
                        "uid": result.id as Any
                    ]) { error in
                        if let error = error {
                            return seal.reject(error)
                        }
                        return seal.fulfill(())
                    }
            }
        }.done {
            self.error = nil
        }.catch { error in
            self.error = error.localizedDescription
        }
        
    }
    
    ///  Returns: nil if fields are correct, else return error message
    func validateFields(_ fields: SignUpFields) -> String? {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            return error
        }
        
        if let error = FormUtilities.validateEmail(email: fields.email) {
            return error
        }
        
        if fields.password != fields.confirmPassword {
            return "Password and confirmation password must be the same."
        }
        
        if let error = FormUtilities.validatePassword(password: fields.password) {
            return error
        }
        
        return nil
    }
}

