//
//  BooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

protocol BooksViewModel {
    var booksProgressPublisher: Published<[BookProgress]>.Publisher { get }
    func refreshBooks()
}
