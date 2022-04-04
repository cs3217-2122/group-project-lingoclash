//
//  PKGameMoveUpdateDelegate.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

protocol PKGameMoveUpdateDelegate {
    var moveListener: PKGameMoveListener? { get set }
    func didMove(move: PKGameMove)
}
