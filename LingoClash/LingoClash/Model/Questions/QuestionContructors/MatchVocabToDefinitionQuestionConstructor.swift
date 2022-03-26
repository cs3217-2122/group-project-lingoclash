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
        guard vocabsTested.count == vocabsTestedCount, otherVocabs.count == otherVocabsCount else {
            return nil
        }
        
        let options = [vocabsTested.map { $0.word }.shuffled(), vocabsTested.map { $0.definition }.shuffled()]
        let answer = Set(vocabsTested.map { [$0.word, $0.definition] })
        return MatchVocabToDefinitionQuestion(context: "Match the Vocabulary to its definition.", options: options, answer: answer, vocabsTested: vocabsTested)
    }
}
