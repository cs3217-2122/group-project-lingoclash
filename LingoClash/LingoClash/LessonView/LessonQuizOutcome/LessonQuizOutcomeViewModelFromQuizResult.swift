//
//  LessonQuizOutcomeViewModelFromQuizResult.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

class LessonQuizOutcomeViewModelFromQuizResult: LessonQuizOutcomeViewModel {
    let starsTotal = 3
    let starsFilled: [Bool]
    let completedStatus: String
    let lessonName: String
    let performanceComment: String
    let vocabsLearnt: [String]
    let isBackgroundDark: Bool
    let actionText: String
    let didPass: Bool
    let lesson: Lesson
    init(lesson: Lesson, quizResult: LessonQuizResult) {
        self.vocabsLearnt = quizResult.vocabsTested.map { $0.word }
        assert(starsTotal >= quizResult.starsObtained)
        self.starsFilled = [Bool](repeating: true, count: quizResult.starsObtained)
                            + [Bool](repeating: false, count: starsTotal - quizResult.starsObtained)
        self.lessonName = quizResult.lessonName
        self.didPass = quizResult.didPass
        self.lesson = lesson
        if quizResult.didPass {
            self.completedStatus = "Completed"
            self.performanceComment = "Mastery in progress"
            self.isBackgroundDark = false
            self.actionText = "Strive for more"
        } else {
            self.completedStatus = "Persevere"
            self.performanceComment = "Let's try that again"
            self.isBackgroundDark = true
            self.actionText = "Try again"
        }
    }
    
    func updateLessonSelection(viewController: LessonSelectionViewController) {
        viewController.viewModel?.refreshLesson(lesson: lesson)
    }

}
