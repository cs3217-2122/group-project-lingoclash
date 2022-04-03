//
//  MatchVocabToDefinitionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

/// Match a vocabulary to its definition
struct MatchVocabToDefinitionQuestion: TwoDisjointSetOptionQuestion, Codable {
    static let vocabsTestedCount = optionsCount
    static let optionsCount: Int = 4
    let vocabsTested: Set<Vocab>
    let context: String
    let options: Set<Pair<String>>
    let answer: Set<Pair<String>>
    
    init(context: String, options: Set<Pair<String>>, answer: Set<Pair<String>>, vocabsTested: Set<Vocab>) {
        self.context = context
        self.options = options
        self.answer = answer
        self.vocabsTested = vocabsTested
    }
    
    func isCorrect(response: Any) -> Bool {
        guard let response = response as? Set<Pair<String>> else {
            return false
        }
        return response == answer
    }
    
}
