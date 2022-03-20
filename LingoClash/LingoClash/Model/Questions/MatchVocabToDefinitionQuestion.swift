//
//  MatchVocabToDefinitionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class MatchVocabToDefinitionQuestion: TwoDisjointSetOptionQuestion {
    static let vocabsTestedCount: Int = 4
    let context: String
    let options: [Set<String>]
    let answer: Set<[String]>
    
    init(context: String, options: [Set<String>], answer: Set<[String]>) {
        self.context = context
        self.options = options
        self.answer = answer
    }
    
    func isCorrect(response: Any) -> Bool {
        guard let response = response as? Set<[String]> else {
            return false
        }
        return response == answer
    }
    
}
