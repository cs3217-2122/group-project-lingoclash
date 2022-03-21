//
//  CompletedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

final class CompletedBooksViewModel: BooksViewModel {
    
    @Published var booksProgress: [BookProgress] = []
    var booksProgressPublisher: Published<[BookProgress]>.Publisher {
        $booksProgress
    }
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user has completed
        booksProgress = [BookProgress(name: "Korean 1", progress: "10/10"),
                         BookProgress(name: "Korean 2", progress: "10/10"),
                         BookProgress(name: "Chinese 1", progress: "10/10")]
    }
}

