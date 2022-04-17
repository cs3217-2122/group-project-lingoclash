//
//  LessonSelectionViewModelFromBook.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

class LessonSelectionViewModelFromBook: LessonSelectionViewModel {
    let starsTotalPerLevel = 3
    private var book: Book
    var lessonTableViewModels: Dynamic<[LessonTableCellViewModel]> = Dynamic([])
    var lessonOverviewViewModel: Dynamic<LessonOverviewViewModel?> = Dynamic(nil)
    var starsObtained: Dynamic<String> = Dynamic("")
    var lessonsPassed: Dynamic<String> = Dynamic("")

    init(book: Book) {
        self.book = book
        reloadLessons()
    }

    func didSelectLesson(at index: Int) {
        let selectedLesson = book.lessons[index]
        self.lessonOverviewViewModel.value = LessonOverviewViewModelFromLesson(lesson: selectedLesson)
    }

    func reloadLessons() {
        self.lessonTableViewModels.value = book.lessons.map { LessonTableCellViewModelFromLesson(lesson: $0) }
        updateStarsObtained()
        updateLessonsPassed()
    }
    
    func refreshLesson(lesson: Lesson) {
        book.lessons = book.lessons.map { oldLesson in
            if lesson == oldLesson {
                return lesson
            } else {
                return oldLesson
            }
        }
        reloadLessons()
    }

    private func updateStarsObtained() {
        let starsObtained = book.lessons.reduce(0, { $0 + $1.stars })
        let starsTotal = book.lessons.count * starsTotalPerLevel
        self.starsObtained.value = String(starsObtained) + "/" + String(starsTotal)
    }

    private func updateLessonsPassed() {
        let levelsPassed = book.lessons.filter { $0.didPass }.count
        let levelTotal = book.lessons.count
        self.lessonsPassed.value = String(levelsPassed) + "/" + String(levelTotal)
    }
}
