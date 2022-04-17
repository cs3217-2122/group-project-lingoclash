//
//  FirebaseAuthProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import PromiseKit

class FirebaseAuthProvider: AuthProvider {

    enum FirebaseAuthError: Error {
        case invalidAuthParams
        case invalidAuthDataResult
    }

    struct Configs {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let usersCollection = "users"
    }

    func register(params: SignUpFields) -> Promise<UserIdentity> {

        Promise<AuthDataResult?> { seal in
            Auth.auth().createUser(withEmail: params.email, password: params.password) { result, error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(result)
            }
        }.then { _ in
            self.getIdentity()
        }
    }

    func login(params: LoginFields) -> Promise<Void> {

        Promise<Void> { seal in
            Auth.auth().signIn(withEmail: params.email, password: params.password) { _, error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(())
            }
        }
    }

    func logout() -> Promise<Void> {
        do {
            try Auth.auth().signOut()
        } catch {
            return Promise.reject(reason: error)
        }

        return Promise<Void>.resolve(value: ())
    }

    func checkError(error: DataProviderErrors.HTTPError) -> Promise<Void> {
        Promise<Void>.resolve(value: ())
    }

    func getIdentity() -> Promise<UserIdentity> {
        let user = Auth.auth().currentUser

        let userIdentity = UserIdentity(
            id: user?.uid, email: user?.email, fullName: user?.displayName, avatar: user?.photoURL?.absoluteString)

        return Promise<UserIdentity>.resolve(value: userIdentity)
    }

    func updateName(_ name: String) -> Promise<Void> {
        Promise<Void> { seal in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(())
            }
        }
    }

    func updateEmail(_ email: String) -> Promise<Void> {
        Promise<Void> { seal in
            Auth.auth().currentUser?.updateEmail(to: email, completion: { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(())
            })
        }
    }

    func updatePassword(_ password: String) -> Promise<Void> {
        Promise<Void> { seal in
            Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(())
            })
        }
    }

    func reauthenticate(password: String) -> Promise<Void> {
        guard let email = Auth.auth().currentUser?.email else {
            return Promise.reject(reason: AuthError.invalidUser)
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        return Promise<Void> { seal in
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { _, error in
                if error != nil {
                    return seal.reject(AuthError.invalidPassword)
                }

                return seal.fulfill(())
            })
        }
    }
}
