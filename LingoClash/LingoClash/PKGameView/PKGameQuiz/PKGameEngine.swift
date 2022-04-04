//
//  PKGameEngine.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//
import Foundation

class PKGameEngine {
    var timeSinceStartOfCurrentQuestion: Date?
    var renderer: PKGameRenderer? {
        didSet {
            loadNextQuestion()
        }
    }
    let questions: [Question]
    private var currQuestionIndex: Int = 0
    var moves: [PKGameMove]
    var players: [Profile]
    var scores: [ Profile: Int ]
    var currentQuestion: Question {
        questions[currQuestionIndex]
    }
    
    init(game: PKGame) {
        self.questions = game.questions
        self.moves = []
        self.players = game.players
        self.scores = [:]
        for player in players {
            scores[player] = 0
        }
    }
    
    func addMove(isCorrect: Bool, playerProfile: Profile) -> PKGameMove? {
        guard players.contains(where: { $0 == playerProfile }) else {
            return nil
        }
        
        guard let timeTaken = getTimeTaken() else {
            return nil
        }
        let move = PKGameMove(question: currentQuestion, player: playerProfile, isCorrect: isCorrect, timeTaken: timeTaken)
        return addMove(move)
    }
        
    func addMove(_ move: PKGameMove) -> PKGameMove? {
        guard isMoveValid(move) else {
            return nil
        }
        moves.append(move)
        renderer?.didAddMove(move)
        
        if shouldLoadNextQuestion() {
            loadNextQuestion()
        }
        
        return move
    }
    
    func shouldLoadNextQuestion() -> Bool {
        return true
        var playersThatAnswered = Set<Profile>()
//        moves.forEach( { move in
//            if move.question.isEqual(to: currentQuestion) {
//                playersThatAnswered.insert(move.player)
//            }
//        })
//        let hasAllPlayersAnsweredQuestion = playersThatAnswered.isSuperset(of: Set(players))
//        return hasAllPlayersAnsweredQuestion
    }
    
    func isMoveValid(_ move: PKGameMove) -> Bool {
        let hasRepeatedExistingMoves = self.moves.contains(where: {
            $0.isRepeated(with: move)
        })
        return !hasRepeatedExistingMoves
    }
    
    private func getTimeTaken() -> Double? {
        guard let timeSinceStartOfCurrentQuestion = timeSinceStartOfCurrentQuestion else {
            assert(false)
            return nil
        }
        let currTime = Date.now
        let timeElasped = currTime.timeIntervalSince(timeSinceStartOfCurrentQuestion)
        return timeElasped
    }
    
    private func loadNextQuestion() {
        guard !isGameComplete() else {
            return gameDidComplete()
        }
        
        self.timeSinceStartOfCurrentQuestion = Date.now
        self.currQuestionIndex += 1
        renderer?.didChangeQuestion(currQuestion: currentQuestion)
    }
    
    private func isGameComplete() -> Bool {
        return currQuestionIndex >= self.questions.count - 1
    }
    
    private func gameDidComplete() {
        guard isGameComplete() else {
            return
        }
        
        guard let gameOutcome = generateGameOutcome() else {
            assert(false)
            return
        }
        
        renderer?.didCompleteGame(gameOutcome: gameOutcome)
    }
    
    private func generateGameOutcome() -> PKGameOutcome? {
        guard isGameComplete() else {
            return nil
        }
        let questionOutcomes = self.questions.map({ question -> [Profile: Bool] in
            let moves = moves.filter({ $0.question.isEqual(to: question)})
            var questionOutcome: [Profile: Bool] = [:]
            for move in moves {
                questionOutcome[move.player] = move.isCorrect
            }
            return questionOutcome
        })
        return PKGameOutcome(questions: self.questions, questionOutcomes: questionOutcomes, scores: self.scores)
    }
}
