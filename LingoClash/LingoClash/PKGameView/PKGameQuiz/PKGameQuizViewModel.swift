//
//  PKGameQuizViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

protocol PKGameQuizViewModel: PKGameRenderer, PKGameUpdateListener {
    var questionViewModel: Dynamic<QuestionViewModel?> { get }
    var gameOverviewViewModel: Dynamic<PKGameOverviewViewModel?> { get }
    var scores: Dynamic<[Int]> { get }
    var playerNames: [String] { get }

    func questionDidComplete(isCorrect: Bool)
    func forfeitGame()
}
