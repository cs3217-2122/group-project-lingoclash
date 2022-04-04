//
//  Level.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

struct LessonData {
    var id: Identifier
    let book_id: Identifier
}

extension LessonData: Record {}
extension LessonData: Hashable {}
