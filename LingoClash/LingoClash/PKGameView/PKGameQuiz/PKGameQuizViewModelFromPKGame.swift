//
//  PKGameQuizViewModelFromPKGame.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

class PKGameQuizViewModelFromPKGame: PKGameQuizViewModel {
    let pkGame: PKGame
    init(game: PKGame) {
        self.pkGame = game
    }
}
