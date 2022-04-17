//
//  AuthErrors.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

enum AuthError: Error {
    case invalidURL
    case invalidParams
    case invalidLoginParams
    case invalidLogoutParams
    case invalidUser
    case invalidPassword
    case invalidCurrentUser
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidUser:
            return NSLocalizedString("The current user is invalid.", bundle: .main, comment: "Invalid user")
        case .invalidPassword:
            return NSLocalizedString("The password is incorrect.", bundle: .main, comment: "Invalid password")
        default:
            return NSLocalizedString("", bundle: .main, comment: "")
        }
    }
}
