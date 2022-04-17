//
//  DevLoginViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 13/4/22.
//

import Foundation
import PromiseKit

class DevLoginViewModel {

    @Published var error: String?

    let testAccounts = AppConfigs.Debug.testAccounts

    private let authProvider: AuthProvider

    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
        self.authProvider = authProvider
    }

    func directLogin(row: Int) {
        #if DEBUG
        let account = testAccounts[row]
        Logger.info("DEBUG mode ON. Bypassing authentication now...")
        Logger.info("You may disable authentication bypass in AppConfigs")

        let email = account.email
        let password = account.password

        let fields = LoginFields(email: email, password: password)
        login(fields)
        #endif
    }

    func login(_ fields: LoginFields) {
        firstly {
            authProvider.login(params: fields)
        }.done {
            self.error = nil
        }.catch { error in
            self.error = error.localizedDescription
        }
    }

}
