//
//  PKGameOutcomeData.swift
//  LingoClash
//
//  Created by Sherwin Poh on 15/4/22.
//

struct PKGameOutcomeData {
    var id: Identifier
    let profile_id: Identifier
    let pk_game_id: Identifier
    let outcome: PKGamePlayerOutcome
}

extension PKGameOutcomeData: Record {}

