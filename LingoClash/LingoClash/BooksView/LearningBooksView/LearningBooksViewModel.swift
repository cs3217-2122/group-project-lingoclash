//
//  LearningBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import Foundation
import Combine

final class LearningBooksViewModel: BooksViewModel {
    
    @Published var booksProgress: [BookProgress] = []
    var booksProgressPublisher: Published<[BookProgress]>.Publisher {
        $booksProgress
    }
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user is learning
        booksProgress = [BookProgress(name: "Korean 3", progress: "1/10")]
    }
}

