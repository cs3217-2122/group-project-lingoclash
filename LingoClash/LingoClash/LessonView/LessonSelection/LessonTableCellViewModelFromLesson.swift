//
//  LessonTableCellViewModelFromLesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

// Assumes that the LessonSelectorViewModel will generate a new view model every update
class LessonTableCellViewModelFromLesson: LessonTableCellViewModel {
    let lesson: Lesson
    let starsTotal = 3

    var starsFilled: [Bool]
    var lessonName: String

    init(lesson: Lesson) {
        self.lesson = lesson
        self.starsFilled = [Bool](repeating: true, count: lesson.stars)
        + [Bool](repeating: false, count: starsTotal - lesson.stars)
        self.lessonName = lesson.name
    }
}
