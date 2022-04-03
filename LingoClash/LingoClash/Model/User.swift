//
//  User.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//
import Foundation

struct User {
    let id: Identifier = UUID().uuidString
    let name: String
    let email: String
}

extension User: Codable {}
