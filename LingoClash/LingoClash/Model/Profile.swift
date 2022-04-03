//
//  Profile.swift
//  testGame
//
//  Created by Sherwin Poh on 3/4/22.
//

import Foundation

struct Profile {
    var id: Identifier = UUID().uuidString
    let user_id: Identifier
    let currentBookId: Identifier
    let email: String
    let name: String
    let stars: Int
    let stars_today: Int
    
}

extension Profile: Codable {}
