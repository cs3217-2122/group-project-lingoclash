//
//  ProfileLevel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct ProfileLessonData {
    var id: Identifier
    let level_id: Identifier
    let stars: Int
}

extension ProfileLessonData: Record {}
