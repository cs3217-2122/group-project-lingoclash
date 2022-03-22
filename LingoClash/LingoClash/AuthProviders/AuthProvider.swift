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
    let fullName: String?
    let avatar: String?
}

protocol AuthProvider {
    func register(params: [String: Any]) -> Promise<Void>
    func login(params: [String: Any]) -> Promise<Void>
    func logout() -> Promise<Void>
    func checkError(error: HTTPError) -> Promise<Void>
    func getIdentity() -> Promise<UserIdentity>
}
