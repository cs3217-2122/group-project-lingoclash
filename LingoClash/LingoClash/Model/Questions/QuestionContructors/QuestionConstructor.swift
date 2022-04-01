//
//  QuestionConstructor.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

protocol QuestionContructor {
    var vocabsTestedCount: Int { get }
    var otherVocabsCount: Int { get }
    func constructQuestion(vocabsTested: Set<BookVocab>, otherVocabs: Set<BookVocab>) -> Question?
}
