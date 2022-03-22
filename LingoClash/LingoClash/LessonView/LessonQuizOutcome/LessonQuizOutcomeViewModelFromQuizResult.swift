//
//  LessonQuizOutcomeViewModelFromQuizResult.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

class LessonQuizOutcomeViewModelFromQuizResult: LessonQuizOutcomeViewModel {
    var quizOutcome: String
    var didPass: Bool
    init(quizResult: LessonQuizResult) {
        self.quizOutcome = quizResult.didPass ? "Passed!" : "Failed"
        self.didPass = quizResult.didPass
    }
}
