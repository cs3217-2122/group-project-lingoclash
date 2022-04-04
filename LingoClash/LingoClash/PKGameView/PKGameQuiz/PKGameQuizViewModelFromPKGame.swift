//
//  PKGameQuizViewModelFromPKGame.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

class PKGameQuizViewModelFromPKGame: PKGameQuizViewModel {
    let moveUpdateDelegate: PKGameMoveUpdateDelegate
    let currentPlayerProfile: Profile
    let pkGame: PKGame
    let pkGameEngine: PKGameEngine
    var questionViewModel: Dynamic<QuestionViewModel?> = Dynamic(nil)
    var gameOverviewViewModel: Dynamic<PKGameOverviewViewModel?> = Dynamic(nil)
    init(game: PKGame, currentPlayerProfile: Profile) {
        self.pkGame = game
        self.moveUpdateDelegate = FirebasePKGameMoveUpdater(game: game)
        self.currentPlayerProfile = currentPlayerProfile
        self.pkGameEngine = PKGameEngine(game: game)
        self.pkGameEngine.renderer = self
    }
    
    func questionDidComplete(isCorrect: Bool) {
        let move = pkGameEngine.addMove(isCorrect: isCorrect, playerProfile: currentPlayerProfile)
        guard let move = move else {
            return
        }
        
        self.moveUpdateDelegate.didMove(move: move)
    }
}

extension PKGameQuizViewModelFromPKGame {
    func didChangeQuestion(currQuestion: Question) {
        self.questionViewModel.value = QuestionViewModelFromQuestion(question: currQuestion)
    }
    
    func didCompleteGame(gameOutcome: PKGameOutcome) {
        self.gameOverviewViewModel.value = PKGameOverviewViewModelFromOutcome(outcome: gameOutcome)
    }
    
    func didAddMove(_ move: PKGameMove) {
    }
}


extension PKGameQuizViewModelFromPKGame {
    func didMove(_ move: PKGameMove) {
        pkGameEngine.addMove(move)
    }
}
