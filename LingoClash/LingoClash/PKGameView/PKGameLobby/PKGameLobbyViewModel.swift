//
//  PKGameLobbyViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

protocol PKGameLobbyViewModel {
    var pkGameQuizViewModel: Dynamic<PKGameQuizViewModel?> { get }

    func cancel()
    func findMatch()
}
