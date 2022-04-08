//
//  CompletedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine
import PromiseKit

final class CompletedBooksViewModel: BooksViewModel {
    
    @Published var error: String?
    @Published var books: [Book] = []
    var booksPublisher: Published<[Book]>.Publisher {
        $books
    }

    private let bookManager = BookManager()
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user has completed
        firstly {
            bookManager.getCompletedBooks()
        }.done { books in
            self.books = books
        }
    }
}

