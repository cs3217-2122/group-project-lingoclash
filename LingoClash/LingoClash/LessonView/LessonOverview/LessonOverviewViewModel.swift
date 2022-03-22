//
//  LessonOverviewViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

protocol LessonOverviewViewModel {
    var lessonName: String { get }
    var vocabs: Dynamic<[String]> { get }
    var lessonVocabViewModel: LessonVocabViewModel { get }
}
