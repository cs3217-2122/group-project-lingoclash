//
//  RecommendedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine
import PromiseKit

final class RecommendedBooksViewModel {
    @Published var isRefreshing = false
    @Published var booksForCategories = [BooksForCategory]()

    private let bookManager = BookManager()

    func refresh() {
        if self.isRefreshing {
            return
        }
        
        self.isRefreshing = true
        firstly {
            bookManager.getRecommendedBooks()
        }.done { booksForCategories in
            self.booksForCategories = booksForCategories
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
    
    func stopRefresh() {
        self.isRefreshing = false
    }

    func learnBook(book: Book) {
        bookManager.markAsLearning(bookId: book.id).catch { error in
            print(error)
        }
    }
}
