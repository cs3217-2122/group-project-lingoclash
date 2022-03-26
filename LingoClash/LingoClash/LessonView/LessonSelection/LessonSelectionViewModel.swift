//
//  LessonSelectionViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

protocol LessonSelectionViewModel {
    var lessonTableViewModels: Dynamic<[LessonTableCellViewModel]> { get }
    var starsObtained: Dynamic<String> { get }
    var levelsPassed: Dynamic<String> { get }
    var lessonOverviewViewModel: Dynamic<LessonOverviewViewModel?> { get }
    func reloadLessons()
    func didSelectLevel(at: Int)
}
