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
        static let uidKey = "uid"
        static let usersCollection = "users"
    }
    
    func register(params: SignUpFields) -> Promise<Void> {
        
        return Promise<AuthDataResult?> { seal in
            Auth.auth().createUser(withEmail: params.email, password: params.password) { (result, error) in
                if let error = error {
                    return seal.reject(error)
                }
                
                return seal.fulfill(result)
            }
        }.then { result -> Promise<Void> in
            guard let result = result else {
                return Promise.reject(reason: FirebaseAuthError.invalidAuthDataResult)
            }
            
            return Promise { seal in
                let db = Firestore.firestore()
                db.collection(Configs.usersCollection).addDocument(
                    data: [
                        Configs.firstNameKey: params.firstName,
                        Configs.lastNameKey: params.lastName,
                        Configs.uidKey: result.user.uid
                    ]) { error in
                        if let error = error {
                            return seal.reject(error)
                        }
                        return seal.fulfill(())
                    }
            }
        }
    }
    
    func login(params: LoginFields) -> Promise<Void> {
        
        return Promise<Void> { seal in
            Auth.auth().signIn(withEmail: params.email, password: params.password) { (result, error) in
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
        return Promise<Void>.resolve(value: ())
    }
    
    func getIdentity() -> Promise<UserIdentity> {
        let user = Auth.auth().currentUser
        
        let userIdentity = UserIdentity(
            id: user?.uid, email: user?.email, fullName: user?.displayName, avatar: user?.photoURL?.absoluteString)
        
        return Promise<UserIdentity>.resolve(value: userIdentity)
    }
    
}
