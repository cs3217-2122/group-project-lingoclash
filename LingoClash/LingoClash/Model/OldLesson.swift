//
//  Lesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

// deprecated. please use Lesson instead
class OldLesson {
    let lessonName: String
    let lessonId: Int
    var stars: Int
    var vocabs = [Vocab]()
    var questions = [Question]()
    var didPass: Bool {
        stars > 0
    }

    init(lessonName: String, lessonId: Int, stars: Int) {
        self.lessonName = lessonName
        self.lessonId = lessonId
        self.stars = stars
    }
}
