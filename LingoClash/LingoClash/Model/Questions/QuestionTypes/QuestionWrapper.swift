//
//  QuestionWrapper.swift
//  testGame
//
//  Created by Sherwin Poh on 3/4/22.
//

struct QuestionWrapper: Codable {
    let question: Question

    private enum CodingKeys: String, CodingKey {
        case questionType, payload
    }

    init(_ question: Question) {
        self.question = question
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let questionType = try container.decode(QuestionType.self, forKey: .questionType)
        // TODO: integrate this with QuestionType enum using extension that maps enum type to QuestionType
        switch questionType {
        case .definitionOption:
            self.question = try container.decode(DefinitionOptionQuestion.self, forKey: .payload)
        case .matchVocabToDefinitionOption:
            self.question = try container.decode(MatchVocabToDefinitionQuestion.self, forKey: .payload)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch question {
        case let payload as DefinitionOptionQuestion:
            try container.encode(QuestionType.definitionOption, forKey: .questionType)
            try container.encode(payload, forKey: .payload)
        case let payload as MatchVocabToDefinitionQuestion:
            try container.encode(QuestionType.matchVocabToDefinitionOption, forKey: .questionType)
            try container.encode(payload, forKey: .payload)
        default:
            break
        }
    }
}
