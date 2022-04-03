//
//  Lesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

struct Lesson {
    let id: Identifier
    let lessonName: String
    var stars: Int
    var vocabs = [Vocab]()
    var questions = [Question]()
    var didPass: Bool {
        stars > 0
    }
    
    init(lessonName: String, lessonId: Int, stars: Int, id: Identifier = UUID().uuidString) {
        self.lessonName = lessonName
        self.id = String(lessonId)
        self.stars = stars
    }
}
