//
//  CompletedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine
import PromiseKit

final class CompletedBooksViewModel: BooksViewModel {

    @Published var isRefreshing = false
    var isRefreshingPublisher: Published<Bool>.Publisher {
        $isRefreshing
    }
    @Published var error: String?
    @Published var books: [Book] = []
    var booksPublisher: Published<[Book]>.Publisher {
        $books
    }

    private let bookManager = BookManager()

    func refresh() {
        if self.isRefreshing {
            return
        }
        
        self.isRefreshing = true
        firstly {
            bookManager.getCompletedBooks()
        }.done { books in
            self.books = books
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
    
    func stopRefresh() {
        self.isRefreshing = false
    }
}
