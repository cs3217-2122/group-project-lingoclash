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

    // TODO: Possibly add a constant to represent a placeholder
    init(question: Question, player: Profile, isCorrect: Bool, timeTaken: Double, id: Identifier = "") {
        self.id = Identifier.placeholder
        self.question = question
        self.player = player
        self.isCorrect = isCorrect
        self.timeTaken = timeTaken
    }

    func isRepeated(with other: PKGameMove) -> Bool {
        self.question.isEqual(to: other.question) && self.player == other.player
    }
}
