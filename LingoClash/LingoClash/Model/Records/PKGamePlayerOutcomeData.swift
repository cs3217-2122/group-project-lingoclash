//
//  PKGameOutcomeData.swift
//  LingoClash
//
//  Created by Sherwin Poh on 15/4/22.
//

struct PKGamePlayerOutcomeData {
    var id: Identifier
    let profile_id: Identifier
    let pk_game_id: Identifier
    let didForfeit: Bool
    let score: Int
    let outcome: PKGamePlayerOutcomeStatus

    init(
        gameId: Identifier,
        gamePlayerOutcome: PKGamePlayerOutcome,
        id: Identifier = Identifier.placeholder) {
        self.id = id
        self.pk_game_id = gameId
        self.profile_id = gamePlayerOutcome.profile.id
        self.score = gamePlayerOutcome.score
        self.outcome = gamePlayerOutcome.outcome
        self.didForfeit = gamePlayerOutcome.didForfeit
    }
}

extension PKGamePlayerOutcomeData: Record {}

extension PKGamePlayerOutcomeData: Hashable {
    static func == (lhs: PKGamePlayerOutcomeData, rhs: PKGamePlayerOutcomeData) -> Bool {
        lhs.profile_id == rhs.profile_id && lhs.pk_game_id == rhs.pk_game_id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(profile_id)
        hasher.combine(pk_game_id)
    }
}
