//
//  JSONServerAuthProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation
import PromiseKit

class JSONServerAuthProvider: AuthProvider {

    struct Configs {
        static let emailKey = "email"
        static let passwordKey = "password"
    }

    private let apiURL: String

    init(apiURL: String) {
        self.apiURL = apiURL
    }

    func register(params: SignUpFields) -> Promise<UserIdentity> {
        let userCredentials = UserCredentials(email: params.email, password: params.password)

        guard let url = URL(string: "\(self.apiURL)/auth/register") else {
            return Promise.reject(
                reason: AuthError.invalidURL)
        }

        guard let data = try? JSONEncoder().encode(userCredentials) else {
            return Promise.reject(reason: AuthError.invalidParams)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        // TODO: fill in method
        return getIdentity()
//        }
    }

    func login(params: LoginFields) -> Promise<Void> {
        let userCredentials = UserCredentials(email: params.email, password: params.password)

        guard let url = URL(string: "\(self.apiURL)/auth/login") else {
            return Promise.reject(
                reason: AuthError.invalidURL)
        }

        guard let data = try? JSONEncoder().encode(userCredentials) else {
            return Promise.reject(reason: AuthError.invalidParams)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return FetchUtilities.fetchData(with: request).done { result in
            guard let auth = try? JSONDecoder().decode(LoginResult.self, from: result.data) else {
                return
            }

            let accessToken = auth.access_token

            try KeychainManager.save(
                service: AppConfigs.API.devService,
                account: AppConfigs.API.accessTokenKey,
                value: accessToken.data(using: .utf8) ?? Data())
        }
    }

    func logout() -> Promise<Void> {

        do {
            try KeychainManager.delete(service: AppConfigs.API.devService, account: AppConfigs.API.accessTokenKey)
        } catch {
            return Promise.reject(reason: error)
        }

        return Promise<Void>.resolve(value: ())
    }

    func checkError(error: HTTPError) -> Promise<Void> {
        switch error {
        case .serverSideError(401), .serverSideError(403):
            do {
                try KeychainManager.delete(service: AppConfigs.API.devService, account: AppConfigs.API.accessTokenKey)
            } catch {
                return Promise.reject(reason: error)
            }
            return Promise.reject(reason: error)
        default:
            return Promise<Void>.resolve(value: ())
        }
    }

    func getIdentity() -> Promise<UserIdentity> {
        guard let url = URL(string: "\(apiURL)/user/me") else {
            return Promise.reject(reason: AuthError.invalidURL)
        }
        let request = URLRequest(url: url)

        return FetchUtilities.fetchData(with: request).compactMap { fetchResult in
            try? JSONDecoder().decode(UserIdentity.self, from: fetchResult.data)
        }
    }

    func updateName(_ name: String) -> Promise<Void> {
        // TODO: fill in method
        return Promise<Void>()
    }

    func updateEmail(_ email: String) -> Promise<Void> {
        // TODO: fill in method
        return Promise<Void>()
    }

    func updatePassword(_ password: String) -> Promise<Void> {
        // TODO: fill in method
        return Promise<Void>()
    }

    func reauthenticate(password: String) -> Promise<Void> {
        // TODO: fill in method
        return Promise<Void>()
    }

}
