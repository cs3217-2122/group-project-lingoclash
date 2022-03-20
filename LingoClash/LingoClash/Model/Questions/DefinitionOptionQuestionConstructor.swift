//
//  DefinitionOptionQuestionConstructor.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class DefinitionOptionQuestionConstructor: QuestionContructor {
    let vocabsNeededToConstruct = DefinitionOptionQuestion.vocabsTestedCount
    
    func constructQuestion(with vocabs: [Vocab]) -> Question? {
        /*
         1. Randomly pick a vocab as the answer
         2. generate options which are just the vocabs.word
         */
        guard vocabsNeededToConstruct == vocabs.count, let correctVocab = vocabs.randomElement() else {
            return nil
        }
        
        let randomVocabs = vocabs.shuffled()
        
        return DefinitionOptionQuestion(context: correctVocab.word, options: randomVocabs.map { $0.definition }, answer: correctVocab.definition)
    }
}
