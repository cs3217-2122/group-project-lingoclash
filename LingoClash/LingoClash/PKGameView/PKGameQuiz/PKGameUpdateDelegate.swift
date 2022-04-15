//
//  PKGameMoveUpdateDelegate.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

protocol PKGameUpdateDelegate {
    var gameUpdateListener: PKGameUpdateListener? { get set }
    func didMove(move: PKGameMove)
    func didForfeit(player: Profile)
    func didCompleteGame(outcome: PKGamePlayerOutcome)
}
