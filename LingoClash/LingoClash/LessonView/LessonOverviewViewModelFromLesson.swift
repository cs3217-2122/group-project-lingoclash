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
        self.retrieveVocabs()
    }
    
    /// Fetches Vocabs using DataProvider, add to lesson, populates vocabs field.
    func retrieveVocabs() {
        // TODO: Temporary, to replace with real data from provider
        let vocabs = [
            Vocab(vocabId: 1, word: "周", definition: "week", sentence: "一周有七天。",
                  sentenceDefinition: "Every week has 7 days.", pronunciationText: "zhōu"),
            Vocab(vocabId: 2, word: "今天", definition: "today", sentence: "她今天看起来很悲伤。",
                  sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān")
        ]
        
        lesson.vocabs = vocabs
        self.vocabs.value = vocabs.map { LessonOverviewViewModelFromLesson.formatVocab(for: $0) }
    }
    
    static func formatVocab(for vocab: Vocab) -> String {
        return vocab.word
    }
    
    static func formatLessonName(for lesson: Lesson) -> String {
        return lesson.lessonName.capitalized
    }
}
