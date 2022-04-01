//
//  LessonOverviewViewModelFromLesson.swiftr.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class LessonOverviewViewModelFromLesson: LessonOverviewViewModel {
    let lesson: BookLesson
    var lessonName: String
    var vocabs = Dynamic<[String]>([String]())
    var lessonVocabViewModel: LessonVocabViewModel {
        LessonVocabViewModelFromLesson(lesson: lesson)
    }
    init(lesson: BookLesson) {
        self.lesson = lesson
        self.lessonName = LessonOverviewViewModelFromLesson.formatLessonName(for: lesson)
        self.retrieveVocabs()
    }
    
    /// Fetches Vocabs using DataProvider, add to lesson, populates vocabs field.
    func retrieveVocabs() {
        // TODO: Temporary, to replace with real data from provider
        let vocabs = [
            BookVocab(vocabId: 1, word: "周", definition: "week", sentence: "一周有七天。",
                      sentenceDefinition: "Every week has 7 days.", pronunciationText: "zhōu"),
            BookVocab(vocabId: 2, word: "今天", definition: "today", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            BookVocab(vocabId: 3, word: "明天", definition: "tomorrow", sentence: "明天10：10",
                      sentenceDefinition: " tomorrow at 10:10", pronunciationText: "míngtiān"),
            BookVocab(vocabId: 4, word: "昨天", definition: "yesterday", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            BookVocab(vocabId: 5, word: "日历", definition: "calendar", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            BookVocab(vocabId: 6, word: "秒", definition: "second", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān")
        ]
        
        lesson.vocabs = vocabs
        self.vocabs.value = vocabs.map { LessonOverviewViewModelFromLesson.formatVocab(for: $0) }
    }
    
    static func formatVocab(for vocab: BookVocab) -> String {
        return vocab.word
    }
    
    static func formatLessonName(for lesson: BookLesson) -> String {
        return lesson.lessonName.capitalized
    }
}
