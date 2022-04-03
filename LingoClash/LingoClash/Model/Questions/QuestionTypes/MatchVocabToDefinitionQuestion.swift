//
//  MatchVocabToDefinitionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

/// Match a vocabulary to its definition
struct MatchVocabToDefinitionQuestion: TwoDisjointSetOptionQuestion {
    static let vocabsTestedCount = optionsCount
    static let optionsCount: Int = 4
    let vocabsTested: Set<Vocab>
    let context: String
    let options: [[String]]
    let answer: Set<[String]>
    
    init(context: String, options: [[String]], answer: Set<[String]>, vocabsTested: Set<Vocab>) {
        self.context = context
        self.options = options
        self.answer = answer
        self.vocabsTested = vocabsTested
    }
    
    func isCorrect(response: Any) -> Bool {
        guard let response = response as? Set<[String]> else {
            return false
        }
        return response == answer
    }
    
}
