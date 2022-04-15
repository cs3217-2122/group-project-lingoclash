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
    
    init(id: Identifier = PKGamePlayerOutcomeData.placeholderId, gameId: Identifier, gamePlayerOutcome: PKGamePlayerOutcome) {
        self.id = id
        self.pk_game_id = gameId
        self.profile_id = gamePlayerOutcome.profile.id
        self.score = gamePlayerOutcome.score
        self.outcome = gamePlayerOutcome.outcome
        self.didForfeit = gamePlayerOutcome.didForfeit
    }
}

extension PKGamePlayerOutcomeData: Record {}

