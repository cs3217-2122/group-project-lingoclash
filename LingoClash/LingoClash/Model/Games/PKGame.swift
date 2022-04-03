//
//  PKGame.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import Foundation

class PKGame {
    static let playerCountRequired: Int = 2
    static let numberOfQuestions: Int = 10
    let id: Identifier
    let createdAt: Date
    var players: [Profile]
    var questions: [Question]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case players
        case questions
    }
    
    init(createdAt: Date, players: [Profile], questions: [Question]) {
        self.createdAt = createdAt
        self.players = players
        self.questions = questions
        self.id = UUID().uuidString
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.id = try container.decode(Identifier.self, forKey: .id)
        self.players = try container.decode([Profile].self, forKey: .players)
        let wrappers = try container.decode([QuestionWrapper].self, forKey: .questions)
        self.questions = wrappers.map { $0.question }
    }
    
    func encode(to encoder: Encoder) throws {
        let wrappers = questions.map { QuestionWrapper($0) }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(players, forKey: .players)
        try container.encode(wrappers, forKey: .questions)
    }
}

extension PKGame: Record {}
