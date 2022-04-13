//
//  PKGameOverviewViewModelFromOutcome.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

class PKGameOverviewViewModelFromOutcome: PKGameOverviewViewModel {
    var didWin: Bool
    var scores: [String]
    var names: [String]
    init(outcome: PKGameOutcome, currentPlayer: Profile) {
        var names: [String] = []
        var scores: [String] = []
        var highest: Int = 0
        var winner: Profile? = nil
        for (key, val) in outcome.scores {
            if val > highest {
                winner = key
                highest = val
            }
            names.append(key.name)
            scores.append(String(val))
        }
        self.names = names
        self.scores = scores
        
        if let winner = winner {
            self.didWin = winner == currentPlayer
        } else {
            self.didWin = false
        }
    }
}
