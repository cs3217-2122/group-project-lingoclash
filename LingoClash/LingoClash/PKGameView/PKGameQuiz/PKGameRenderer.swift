//
//  PKGameRenderer.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

protocol PKGameRenderer {
    func didChangeQuestion(currQuestion: Question)
    func didCompleteGame(gameOutcome: PKGameOutcome)
    func didAddMove(_ move: PKGameMove)
    func didIncrementScore(newScore: Int, change: Int, player: Profile)
    func didAccountForForfeit(player: Profile)
}
