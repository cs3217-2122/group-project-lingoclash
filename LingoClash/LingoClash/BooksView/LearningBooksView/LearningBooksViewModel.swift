//
//  LearningBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import Foundation
import Combine
import PromiseKit

final class LearningBooksViewModel: BooksViewModel {
    
    @Published var books: [Book] = []
    var booksPublisher: Published<[Book]>.Publisher {
        $books
    }
    
    private let bookManager = BookManager()
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user is learning
        firstly {
            bookManager.getLearningBooks()
        }.done { books in
            self.books = books
        }
    }
}

