//
//  LessonOverviewViewModelFromLesson.swiftr.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class LessonOverviewViewModelFromLesson: LessonOverviewViewModel {
    let lesson: Lesson
    var lessonName: String
    var vocabs = Dynamic<[String]>([String]())
    var lessonVocabViewModel: LessonVocabViewModel {
        LessonVocabViewModelFromLesson(lesson: lesson)
    }
    init(lesson: Lesson) {
        self.lesson = lesson
        self.lessonName = LessonOverviewViewModelFromLesson.formatLessonName(for: lesson)
        retrieveVocabs()
    }
    
    /// Fetches Vocabs using DataProvider, add to lesson, populates vocabs field.
    func retrieveVocabs() {
        self.vocabs.value = lesson.vocabs.map { LessonOverviewViewModelFromLesson.formatVocab(for: $0) }
    }
    
    static func formatVocab(for vocab: Vocab) -> String {
        return vocab.word
    }
    
    static func formatLessonName(for lesson: Lesson) -> String {
        return lesson.name.capitalized
    }
}
