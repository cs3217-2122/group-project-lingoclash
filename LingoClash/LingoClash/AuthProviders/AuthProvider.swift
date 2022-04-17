//
//  AuthProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation
import PromiseKit

struct UserIdentity: Codable {
    let id: Identifier?
    let email: String?
    let fullName: String?
    let avatar: String?
}

protocol AuthProvider {
    func register(params: SignUpFields) -> Promise<UserIdentity>
    func login(params: LoginFields) -> Promise<Void>
    func logout() -> Promise<Void>
    func checkError(error: DataProviderErrors.HTTPError) -> Promise<Void>
    func getIdentity() -> Promise<UserIdentity>
    func updateName(_ name: String) -> Promise<Void>
    func updateEmail(_ email: String) -> Promise<Void>
    func updatePassword(_ password: String) -> Promise<Void>
    func reauthenticate(password: String) -> Promise<Void>
}
