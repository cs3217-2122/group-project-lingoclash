//
//  PKGameLobbyViewModelFromUser.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import PromiseKit

class PKGameLobbyViewModelFromProfile: PKGameLobbyViewModel {
    private let playerProfile: Profile
    private let matchFinder: PKGameMatchFinder
    let pkGameQuizViewModel: Dynamic<PKGameQuizViewModel?> = Dynamic(nil)

    init(playerProfile: Profile, matchFinder: PKGameMatchFinder = FirebasePKGameMatchFinder()) {
        self.playerProfile = playerProfile
        self.matchFinder = matchFinder
    }

    func findMatch() {
        firstly {
            matchFinder.findGame(playerProfile: playerProfile)
        }.done { game in
            self.pkGameQuizViewModel.value = PKGameQuizViewModelFromPKGame(
                game: game,
                currentPlayerProfile: self.playerProfile)
        }.catch { error in
            assert(false)
            print(error)
        }
    }

    func cancel() {
        matchFinder.cancel(playerProfile: playerProfile)
    }
}
