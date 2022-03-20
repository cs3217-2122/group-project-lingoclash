//
//  DefinitionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

/// Returns a question that gives a word and asks for its definition
class DefinitionOptionQuestion: SimpleOptionQuestion {
    static let vocabsTestedCount: Int = 4
    let context: String
    let options: [String]
    let answer: String

    init(context: String, options: [String], answer: String) {
        self.context = context
        self.options = options
        self.answer = answer
    }
    
    func isCorrect(response: Any) -> Bool {
        guard let response = response as? String else {
            return false
        }
        return response == answer
    }
}
