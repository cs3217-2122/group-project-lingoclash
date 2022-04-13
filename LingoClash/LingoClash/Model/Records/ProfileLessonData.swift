//
//  ProfileLevel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileLessonData {
    var id: Identifier
    let profile_book_id: Identifier
    let lesson_id: Identifier
    let stars: Int
}

extension ProfileLessonData: Record {}
