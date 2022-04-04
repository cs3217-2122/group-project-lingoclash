//
//  PKGameMove.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import Foundation

struct PKGameMove {
    let id: Identifier
    let question: Question
    let player: Profile
    let isCorrect: Bool
    let timeTaken: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case question
        case player
        case isCorrect
        case timeTaken
    }
    
    init(question: Question, player: Profile, isCorrect: Bool, timeTaken: Double, id: String = UUID().uuidString) {
        self.question = question
        self.player = player
        self.isCorrect = isCorrect
        self.timeTaken = timeTaken
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.player = try container.decode(Profile.self, forKey: .player)
        self.isCorrect = try container.decode(Bool.self, forKey: .isCorrect)
        self.timeTaken = try container.decode(Double.self, forKey: .timeTaken)
        self.id = try container.decode(Identifier.self, forKey: .id)
        let wrapper = try container.decode(QuestionWrapper.self, forKey: .question)
        self.question = wrapper.question
    }
    
    func encode(to encoder: Encoder) throws {
        let wrapper = QuestionWrapper(question)

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(player, forKey: .player)
        try container.encode(isCorrect, forKey: .isCorrect)
        try container.encode(timeTaken, forKey: .timeTaken)
        try container.encode(id, forKey: .id)
        try container.encode(wrapper, forKey: .question)
    }
    
    func isRepeated(with other: PKGameMove) -> Bool {
        return self.question.isEqual(to: other.question) && self.player == other.player
    }
}

extension PKGameMove: Codable {}
