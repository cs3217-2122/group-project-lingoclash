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
    private let profileManager = ProfileManager()

    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
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
        }.then { userIdentity -> Promise<Profile> in
            guard let userId = userIdentity.id else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }
            return self.profileManager.createProfile(params: fields, userId: userId)
        }.done { _ in
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
