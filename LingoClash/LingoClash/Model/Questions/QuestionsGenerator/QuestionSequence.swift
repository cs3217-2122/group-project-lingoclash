//
//  QuestionSequence.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

struct QuestionSequence: QuerySequence {
    var scopeFactory: QuestionScopeFactory
    var constructorFactory: QuestionConstructorRandomFactory
    var questionsLeft: Int?
    mutating func next() -> Query? {
        if let questionsLeft = questionsLeft {
            guard questionsLeft > 0 else {
                return nil
            }
            self.questionsLeft = questionsLeft - 1
        }
        let constructor = constructorFactory.getQuestionConstructor()
        let (testedVocab, otherVocabs) = scopeFactory.getScope(for: constructor)
        let question = constructor.constructQuestion(vocabsTested: testedVocab, otherVocabs: otherVocabs)
        return question
    }
}
