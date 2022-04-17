//
//  LessonVocabViewModelFromLesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

class LessonVocabViewModelFromLesson: LessonVocabViewModel {
    
    let lesson: Lesson
    var currIndex: Dynamic<Int> = Dynamic(0)
    
    var vocab: Vocab

    var currVocab: Dynamic<String>
    var currVocabDefinition: Dynamic<String>
    var currVocabPronounciation: Dynamic<String>
    var currSentence: Dynamic<String>
    var currSentenceDefinition: Dynamic<String>
    var isLastVocab: Dynamic<Bool>
    var isFirstVocab: Dynamic<Bool>
    var lessonQuizViewModel: LessonQuizViewModel

    init(lesson: Lesson) {
        assert(lesson.vocabs.count > 0)
        self.lesson = lesson
        let currVocab = lesson.vocabs[self.currIndex.value]
        self.vocab = currVocab
        self.currVocab = Dynamic(currVocab.word)
        self.currVocabDefinition = Dynamic(currVocab.definition)
        self.currVocabPronounciation = Dynamic(currVocab.pronunciationText)
        self.currSentence = Dynamic(currVocab.sentence)
        self.currSentenceDefinition = Dynamic(currVocab.sentenceDefinition)
        self.isFirstVocab = Dynamic(true)
        self.isLastVocab = Dynamic(lesson.vocabs.count == self.currIndex.value - 1)
        self.lessonQuizViewModel = LessonQuizViewModelFromLesson(lesson: lesson)
    }

    func reload() {
        updateCurrVocabInfo(currIndex: 0)
        self.lessonQuizViewModel = LessonQuizViewModelFromLesson(lesson: lesson)
    }

    func navigateNext() {
        guard !isLastVocab.value else {
            return
        }
        updateCurrVocabInfo(currIndex: self.currIndex.value + 1)
    }
    func navigatePrev() {
        guard !isFirstVocab.value else {
            return
        }

        updateCurrVocabInfo(currIndex: self.currIndex.value - 1)
    }

    private func updateCurrVocabInfo(currIndex: Int) {
        let isWithinRange = currIndex < lesson.vocabs.count && currIndex >= 0
        guard isWithinRange else {
            return
        }
        self.currIndex.value = currIndex
        let currVocab = lesson.vocabs[self.currIndex.value]
        self.currVocab.value = currVocab.word
        self.currVocabDefinition.value = currVocab.definition
        self.currVocabPronounciation.value = currVocab.pronunciationText
        self.currSentence.value = currVocab.sentence
        self.currSentenceDefinition.value = currVocab.sentenceDefinition
        self.isFirstVocab.value = self.currIndex.value == 0
        self.isLastVocab.value = lesson.vocabs.count - 1 == self.currIndex.value
    }
}
