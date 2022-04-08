//
//  BooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

protocol BooksViewModel {
    var booksPublisher: Published<[Book]>.Publisher { get }
    func refreshBooks()
}
