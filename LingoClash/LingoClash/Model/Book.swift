//
//  Book.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation


enum BookStatus {
    case unread
    case learning
    case completed
}

struct Book {
    let id: Identifier
    let category: BookCategory
    let name: String
    let totalLessons: Int
    let passedLessons: Int
    let lessons: [Lesson]
    let status: BookStatus
    
    var progress: Float {
        Float(passedLessons / totalLessons)
    }
    var progressText: String {
        "Progress: \(passedLessons) / \(totalLessons)"
    }
    var totalStars: Int {
        let totalStarsPerLesson = 3
        return totalLessons * totalStarsPerLesson
    }
    
    init(bookData: BookData, vocabsByLesson: [LessonData: [VocabData]], bookCategoryData: BookCategoryData, profileBookData: ProfileBookData?, profileLessonsData: [ProfileLessonData]) {
        self.category = BookCategory(bookCategoryData: bookCategoryData)
        self.id = bookData.id
        self.name = bookData.name
        self.totalLessons = vocabsByLesson.count
        
        var passedLessonsCount = 0
        var profileLessonsByLessonId = [Identifier: ProfileLessonData]()
        let profileLessons = profileLessonsData
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
        
        if let profileBookData = profileBookData {
            self.status = profileBookData.is_completed ? .completed : .learning
        } else {
            self.status = .unread
        }
    }
}
