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
    
    @Published var isRefreshing = false
    var isRefreshingPublisher: Published<Bool>.Publisher {
        $isRefreshing
    }
    @Published var books: [Book] = []
    var booksPublisher: Published<[Book]>.Publisher {
        $books
    }
    
    private let bookManager = BookManager()
    
    func refresh() {
        self.isRefreshing = true
        firstly {
            bookManager.getLearningBooks()
        }.done { books in
            self.books = books
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
}

