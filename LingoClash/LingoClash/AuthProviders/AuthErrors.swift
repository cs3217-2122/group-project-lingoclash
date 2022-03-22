//
//  AuthErrors.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation


enum AuthError: Error  {
    case invalidURL
    case invalidParams
    case invalidLoginParams
    case invalidLogoutParams
}
