//
//  PKGameQuizViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

protocol PKGameQuizViewModel: PKGameRenderer, PKGameMoveListener {
    var questionViewModel: Dynamic<QuestionViewModel?> { get }
    var gameOverviewViewModel: Dynamic<PKGameOverviewViewModel?> { get }
    
    func questionDidComplete(isCorrect: Bool)
}
