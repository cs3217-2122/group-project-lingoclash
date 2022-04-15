//
//  PKGameMoveListener.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

protocol PKGameUpdateListener {
    func didMove(_ move: PKGameMove)
    func didForfeit(player: Profile)
}
