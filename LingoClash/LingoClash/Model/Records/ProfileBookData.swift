//
//  ProfileBook.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileBookData {
    var id: Identifier
    let profile_id: Identifier
    let book_id: Identifier
    let is_completed: Bool
}

extension ProfileBookData: Record {}
