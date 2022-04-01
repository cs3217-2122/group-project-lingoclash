//
//  Lesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class BookLesson {
    let lessonName: String
    let lessonId: Int
    var stars: Int
    var vocabs = [BookVocab]()
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
