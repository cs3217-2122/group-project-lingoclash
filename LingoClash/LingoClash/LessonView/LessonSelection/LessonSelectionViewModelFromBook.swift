//
//  LessonSelectionViewModelFromBook.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

class LessonSelectionViewModelFromBook: LessonSelectionViewModel {
    let starsTotalPerLevel = 3
    private let book: BookData
    private var lessons: [OldLesson] = []
    var lessonTableViewModels: Dynamic<[LessonTableCellViewModel]> = Dynamic([])
    var lessonOverviewViewModel: Dynamic<LessonOverviewViewModel?> = Dynamic(nil)
    var starsObtained: Dynamic<String> = Dynamic("")
    var levelsPassed: Dynamic<String> = Dynamic("")
    
    init(book: BookData) {
        self.book = book
        reloadLessons()
    }
    
    func didSelectLevel(at index: Int) {
        let selectedLesson = lessons[index]
        self.lessonOverviewViewModel.value = LessonOverviewViewModelFromLesson(lesson: selectedLesson)
    }
    
    func reloadLessons() {
        // TODO: TO replace with actual data fetching
        self.lessons = makeShiftGetter(book: book)
        self.lessonTableViewModels.value = self.lessons.map { LessonTableCellViewModelFromLesson(lesson: $0) }
        updateStarsObtained()
        updateLevelsPassed()
    }
    
    private func updateStarsObtained() {
        let starsObtained = self.lessons.reduce(0, { $0 + $1.stars })
        let starsTotal = self.lessons.count * starsTotalPerLevel
        self.starsObtained.value = String(starsObtained) + "/" + String(starsTotal)
    }
    
    private func updateLevelsPassed() {
        let levelsPassed = self.lessons.filter { $0.didPass }.count
        let levelTotal = self.lessons.count
        self.levelsPassed.value = String(levelsPassed) + "/" + String(levelTotal)
    }
    
    private func makeShiftGetter(book: BookData) -> [OldLesson] {
        let lesson1 = OldLesson(lessonName: "Lesson 1", lessonId: 1, stars: 2)
        let lesson2 = OldLesson(lessonName: "Lesson 2", lessonId: 2, stars: 3)
        let lesson3 = OldLesson(lessonName: "Lesson 3", lessonId: 3, stars: 0)
        let lesson4 = OldLesson(lessonName: "Lesson 4", lessonId: 4, stars: 1)
        return [lesson1, lesson2, lesson3, lesson4]
    }
}
