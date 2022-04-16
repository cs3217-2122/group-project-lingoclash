//
//  Lesson.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct Lesson {
    var id: Identifier
    var vocabs: [Vocab]
    var stars: Int
    var name: String

    var questions = [Question]()
    var didPass: Bool {
        stars > 0
    }

    init(lessonData: LessonData, vocabs: [Vocab], profileLessonData: ProfileLessonData?) {
        self.id = lessonData.id
        self.vocabs = vocabs
        self.name = lessonData.name
        self.stars = profileLessonData?.stars ?? 0
    }

    mutating func completeQuiz(result: LessonQuizResult) {
        self.stars = result.starsObtained
    }
}
