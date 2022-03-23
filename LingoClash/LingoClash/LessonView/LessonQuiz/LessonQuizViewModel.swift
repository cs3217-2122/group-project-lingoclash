//
//  LessonQuizViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

protocol LessonQuizViewModel {
    var questionViewModel: Dynamic<QuestionViewModel?> { get }
    var quizOutcomeViewModel: LessonQuizOutcomeViewModel? { get }
    var quizStatus: Dynamic<QuizStatus> { get }
    var starPositions: [Float] { get }
    var progress: Dynamic<Float> { get }
    var livesLeft: Dynamic<Int> { get }
    func questionDidComplete(isCorrect: Bool)
}

enum QuizStatus {
    case incomplete
    case failed
    case passed
}
