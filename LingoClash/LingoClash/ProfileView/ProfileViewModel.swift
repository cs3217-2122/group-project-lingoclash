//
//  ProfileViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

final class ProfileViewModel {
    
    @Published var error: String?
    @Published var alertContent: AlertContent?
    
    private let authProvider: AuthProvider
    
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
    
}
