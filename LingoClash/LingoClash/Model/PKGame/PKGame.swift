//
//  PKGame.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import Foundation

class PKGame {
    static let playerCountRequired: Int = 2
    static let numberOfQuestions: Int = 3
    let id: Identifier
    var players: [Profile]
    var questions: [Question]

    init(id: Identifier, players: [Profile], questions: [Question]) {
        self.id = id
        self.players = players
        self.questions = questions
    }
}
