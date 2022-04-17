//
//  LessonVocabViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

protocol LessonVocabViewModel {
    var vocab: Vocab { get }
    var currVocab: Dynamic<String> { get }
    var currVocabDefinition: Dynamic<String> { get }
    var currVocabPronounciation: Dynamic<String> { get }
    var currSentence: Dynamic<String> { get }
    var currSentenceDefinition: Dynamic<String> { get }
    var isLastVocab: Dynamic<Bool> { get }
    var isFirstVocab: Dynamic<Bool> { get }
    var lessonQuizViewModel: LessonQuizViewModel { get }
    func navigateNext()
    func navigatePrev()
    func reload()
}
