//
//  PKGameOutcome.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

struct PKGameOutcome {
    var questionOutcomes: [PKGameQuestionOutcome]
    var playerOutcomes: [PKGamePlayerOutcome]
}

struct PKGameQuestionOutcome {
    let question: Question
    let outcome: [Profile: Bool]
}

struct PKGamePlayerOutcome {
    let profile: Profile
    let score: Int
    let didForfeit: Bool
    let outcome: PKGamePlayerOutcomeStatus
}

enum PKGamePlayerOutcomeStatus: String, Codable {
    case win
    case lose
    case draw
}
