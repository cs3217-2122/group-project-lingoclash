//
//  RecommendedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

final class RecommendedBooksViewModel {
    
    @Published var booksWithCategories: BooksWithCategories = BooksWithCategories()
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user has not completed, and preprocess into BooksWithCategories format
        let categories = ["Japanese", "Chinese"]
        let books = ["Japanese":["Japanese 1 2020 Edition", "Japanese 2", "Japanese 3", "Japanese 4"], "Chinese": ["Chinese 1"]]
        booksWithCategories = BooksWithCategories(categories: categories, books: books)
    }
}

struct BooksWithCategories {
    let categories: [String]
    let books: [String: [String]]
    
    init() {
        self.init(categories: [], books: [:])
    }
    
    init(categories: [String], books: [String: [String]]) {
        self.categories = categories
        self.books = books
    }
}
