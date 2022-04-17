//
//  LessonQuizOutcomeViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

protocol LessonQuizOutcomeViewModel {
    var lesson: Lesson { get }
    var starsFilled: [Bool] { get }
    var completedStatus: String { get }
    var lessonName: String { get }
    var performanceComment: String { get }
    var vocabsLearnt: [String] { get }
    var isBackgroundDark: Bool { get }
    var actionText: String { get }
    var didPass: Bool { get }
    func updateLessonSelection(viewController: LessonSelectionViewController)
}
