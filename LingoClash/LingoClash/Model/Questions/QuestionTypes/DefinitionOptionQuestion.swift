//
//  DefinitionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

/// Returns a question that gives a word and asks for its definition
struct DefinitionOptionQuestion: SimpleOptionQuestion, Codable {
    static let vocabsTestedCount: Int = 1
    static let optionsCount: Int = 4
    // Represents the vocabs that are in the scope of the question
    let vocabsTested: Set<Vocab>
    let context: String
    let options: [String]
    let answer: String
    
    // Represents the string representation of the answer
    let answerToString: String

    init(context: String, options: [String], answer: String, vocabsTested: Set<Vocab>) {
        self.context = context
        self.options = options
        self.answer = answer
        self.answerToString = answer
        
        self.vocabsTested = vocabsTested
    }

    func isCorrect(response: Any) -> Bool {
        guard let response = response as? String else {
            return false
        }
        return response == answer
    }

    func isEqual(to other: Question) -> Bool {
        guard let other = other as? DefinitionOptionQuestion else {
            return false
        }
        return self == other
    }
}

extension DefinitionOptionQuestion: Equatable {}
