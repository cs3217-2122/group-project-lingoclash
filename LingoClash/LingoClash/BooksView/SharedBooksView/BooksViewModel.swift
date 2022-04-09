//
//  BooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

protocol BooksViewModel {
    var isRefreshingPublisher: Published<Bool>.Publisher { get }
    var booksPublisher: Published<[Book]>.Publisher { get }
    func refresh()
}
