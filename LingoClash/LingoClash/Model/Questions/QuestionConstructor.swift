//
//  QuestionConstructor.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

protocol QuestionContructor {
    var vocabsNeededToConstruct: Int { get }
    func constructQuestion(with vocabs: [Vocab]) -> Question?
}
