//
//  PKGameData.swift
//  LingoClash
//
//  Created by Sherwin Poh on 13/4/22.
//

import Foundation

struct PKGameData {
    var id: Identifier
    let createdAt: Date
    let players: [ProfileData]
    let questions: [Question]
    let forfeittedPlayers: Set<Identifier>

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case players
        case forfeittedPlayers
        case questions
    }

    // Local creation of PKGameData to be pushed to DataProvider
    init(createdAt: Date, players: [ProfileData], questions: [Question], forfeittedPlayers: Set<Identifier> = Set()) {
        self.createdAt = createdAt
        self.players = players
        self.questions = questions
        self.forfeittedPlayers = forfeittedPlayers
        self.id = Identifier.placeholder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.id = try container.decode(Identifier.self, forKey: .id)
        self.players = try container.decode([ProfileData].self, forKey: .players)
        self.forfeittedPlayers = try container.decode(Set<Identifier>.self, forKey: .forfeittedPlayers)
        let wrappers = try container.decode([QuestionWrapper].self, forKey: .questions)
        self.questions = wrappers.map { $0.question }
    }

    func encode(to encoder: Encoder) throws {
        let wrappers = questions.map { QuestionWrapper($0) }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(players, forKey: .players)
        try container.encode(forfeittedPlayers, forKey: .forfeittedPlayers)
        try container.encode(wrappers, forKey: .questions)
    }
}

extension PKGameData: Record {}
