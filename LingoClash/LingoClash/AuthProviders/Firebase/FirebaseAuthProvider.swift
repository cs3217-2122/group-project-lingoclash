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

    // TODO: think of better error names
    enum FirebaseAuthError: Error {
        case invalidAuthParams
        case invalidAuthDataResult
    }

    struct Configs {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let uidKey = "uid"
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
        }.then { result -> Promise<Void> in
            guard let _ = result else {
                return Promise.reject(reason: FirebaseAuthError.invalidAuthDataResult)
            }

            return Promise { seal in
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = params.name
                changeRequest?.commitChanges { error in
                    if let error = error {
                        return seal.reject(error)
                    }

                    return seal.fulfill(())
                }
            }
        }.then {
            self.getIdentity()
        }.then { userIdentity -> Promise<UserIdentity> in
            guard let id = userIdentity.id,
                  let name = userIdentity.fullName,
                  let email = userIdentity.email else {
                return Promise.reject(reason: FirebaseAuthError.invalidAuthDataResult)
            }
            let newProfileData = ProfileData(id: ProfileData.placeholderId,
                                             book_id: nil,
                                             user_id: id,
                                             name: name,
                                             email: email,
                                             stars: 0,
                                             stars_today: 0,
                                             stars_goal: 10,
                                             bio: "Learning a language doesn't always have to be civil.",
                                             days_learning: 0,
                                             vocabs_learnt: 0,
                                             pk_winning_rate: 100)
            let createdProfileData = ProfileManager().create(newRecord: newProfileData)
            return createdProfileData.map { _ in
                userIdentity
            }
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

    func checkError(error: HTTPError) -> Promise<Void> {
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
                if let _ = error {
                    return seal.reject(AuthError.invalidPassword)
                }

                return seal.fulfill(())
            })
        }
    }
}
