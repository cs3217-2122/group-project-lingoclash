//
//  Book.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct BookCategory {
    let id: Identifier
    let name: String
    
    init(bookCategoryData: BookCategoryData) {
        self.id = bookCategoryData.id
        self.name = bookCategoryData.name
    }
}

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
        self.name = ""
        self.stars = profileLessonData?.stars ?? 0
    }
}

struct Book {
    let id: Identifier
    let category: BookCategory
    let name: String
    let isCompleted: Bool
    let totalLessons: Int
    let passedLessons: Int
    let lessons: [Lesson]
    var progress: String {
        "\(passedLessons) / \(totalLessons)"
    }
    
    init(bookData: BookData, vocabsByLesson: [LessonData: [VocabData]], bookCategoryData: BookCategoryData, profileBookData: ProfileBookData?) {
        self.category = BookCategory(bookCategoryData: bookCategoryData)
        self.id = bookData.id
        self.name = bookData.name
        self.totalLessons = vocabsByLesson.count
        
        var passedLessonsCount = 0
        var profileLessonsByLessonId = [Identifier: ProfileLessonData]()
        let profileLessons = profileBookData?.profile_lessons ?? []
        for profileLesson in profileLessons {
            if profileLesson.stars > 0 {
                passedLessonsCount += 1
            }
            profileLessonsByLessonId[profileLesson.lesson_id] = profileLesson
        }
        self.passedLessons = passedLessonsCount
        
        var bookLessons = [Lesson]()
        for (lessonData, vocabsData) in vocabsByLesson {
            let vocabs = vocabsData.map { Vocab(vocabData: $0) }
        
            bookLessons.append(Lesson(lessonData: lessonData, vocabs: vocabs, profileLessonData: profileLessonsByLessonId[lessonData.id]))
        }
        self.lessons = bookLessons
        self.isCompleted = profileBookData?.is_completed ?? false
    }
}
