//
//  MatchVocabToDefinitionQuestionConstructor.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

struct MatchVocabToDefinitionQuestionConstructor: QuestionContructor {
    let vocabsTestedCount = MatchVocabToDefinitionQuestion.vocabsTestedCount
    let otherVocabsCount = 0

    func constructQuestion(vocabsTested: Set<Vocab>, otherVocabs: Set<Vocab>) -> Question? {
        nil
    }
}
