//
//  Lesson.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct Lesson {
    let id: Identifier
    let vocabs: [Vocab]
    let stars: Int
    let name: String
    
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
}
