//
//  DefinitionOptionQuestionConstructor.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

struct DefinitionOptionQuestionConstructor: QuestionContructor {
    let vocabsTestedCount = DefinitionOptionQuestion.vocabsTestedCount
    let otherVocabsCount = DefinitionOptionQuestion.optionsCount - DefinitionOptionQuestion.vocabsTestedCount

    func constructQuestion(vocabsTested: Set<Vocab>, otherVocabs: Set<Vocab>) -> Question? {
        guard vocabsTested.count == vocabsTestedCount,
              otherVocabs.count == otherVocabsCount,
              let correctVocab = vocabsTested.first else {
            return nil
        }

        let vocabs = vocabsTested.union(otherVocabs)
        let options = vocabs.map { $0.definition }.shuffled()
        return DefinitionOptionQuestion(
            context: correctVocab.word,
            options: options,
            answer: correctVocab.definition,
            vocabsTested: vocabsTested)
    }
}
