//
//  LoginViewModel.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

final class SplashViewModel {

    @Published var error: String?

    private let authProvider: AuthProvider

    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
        self.authProvider = authProvider
    }

    func login(_ fields: LoginFields) {
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
    func validateFields(_ fields: LoginFields) -> String? {
        if let error = FormUtilities.validateFieldsNotEmpty(fields) {
            return error
        }

        if let error = FormUtilities.validateEmail(email: fields.email) {
            return error
        }

        return nil
    }

}
