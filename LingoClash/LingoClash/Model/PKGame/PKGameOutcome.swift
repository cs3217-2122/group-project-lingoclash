//
//  PKGameOutcome.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

struct PKGameOutcome {
    var questions: [Question]
    var questionOutcomes: [[Profile: Bool]]
    var scores: [Profile: Int]
    var playerOutcomes: [Profile: PKGamePlayerOutcome]
}

enum PKGamePlayerOutcome: String, Codable {
    case win
    case lose
    case draw
}
