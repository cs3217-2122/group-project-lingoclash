//
//  PKGameQuizViewModelFromPKGame.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

class PKGameQuizViewModelFromPKGame: PKGameQuizViewModel {
    var gameUpdateDelegate: PKGameUpdateDelegate
    let currentPlayerProfile: Profile
    let pkGame: PKGame
    let pkGameEngine: PKGameEngine
    var questionViewModel: Dynamic<QuestionViewModel?> = Dynamic(nil)
    var gameOverviewViewModel: Dynamic<PKGameOverviewViewModel?> = Dynamic(nil)
    var playerNames: [String]
    private var players: [Profile]
    var scores: Dynamic<[Int]>
    init(game: PKGame, currentPlayerProfile: Profile) {
        self.pkGame = game
        self.gameUpdateDelegate = FirebasePKGameUpdater(game: game)
        self.currentPlayerProfile = currentPlayerProfile
        self.players = [currentPlayerProfile] + game.players.filter { $0 != currentPlayerProfile }
        self.playerNames = self.players.map({ $0.name.capitalized })
        self.scores = Dynamic(self.players.map({ _ in
            0
        }))

        self.pkGameEngine = PKGameEngine(game: game)

        self.pkGameEngine.renderer = self
        self.gameUpdateDelegate.gameUpdateListener = self

    }

    func questionDidComplete(isCorrect: Bool) {
        let move = pkGameEngine.addMove(isCorrect: isCorrect, playerProfile: currentPlayerProfile)
        guard let move = move else {
            return
        }

        self.gameUpdateDelegate.didMove(move: move)
    }

    func forfeitGame() {
        let didSucessfullyForfeit = pkGameEngine.forfeitGame(player: currentPlayerProfile)
        guard didSucessfullyForfeit else {
            print("Unable to forfeit game.")
            // TODO: Tell user this failure
            return
        }

        gameUpdateDelegate.didForfeit(player: currentPlayerProfile)
    }
}

// MARK: PKGameRenderer methods
extension PKGameQuizViewModelFromPKGame {
    func didChangeQuestion(currQuestion: Question) {
        self.questionViewModel.value = QuestionViewModelFromQuestion(question: currQuestion)
    }

    func didCompleteGame(gameOutcome: PKGameOutcome) {
        guard let currPlayerOutcome = gameOutcome.playerOutcomes.first(
            where: { $0.profile == currentPlayerProfile }) else {
            print("current player outcome not found.")
            assert(false)
            return
        }
        self.gameUpdateDelegate.didCompleteGame(outcome: currPlayerOutcome)
        self.gameOverviewViewModel.value = PKGameOverviewViewModelFromOutcome(
            outcome: gameOutcome,
            currentPlayer: currentPlayerProfile)
    }

    func didAddMove(_ move: PKGameMove) {
    }

    func didIncrementScore(newScore: Int, change: Int, player: Profile) {
        var newScores = self.scores.value
        guard let index = players.firstIndex(of: player) else {
            assert(false)
            return
        }
        newScores[index] = newScore
        self.scores.value = newScores
    }

    func didAccountForForfeit(player: Profile) {
        // TODO: Add some notif that a person has forfeitted
        print("renderer update forfeit.")
    }
}

// MARK: PKGameUpdateListener
extension PKGameQuizViewModelFromPKGame {
    func didMove(_ move: PKGameMove) {
        _ = pkGameEngine.addMove(move)
    }

    func didForfeit(player: Profile) {
        // TODO: Add some notif that a person has forfeitted
        _ = pkGameEngine.forfeitGame(player: player)
        print("renderer update forfeit.")
    }
}
