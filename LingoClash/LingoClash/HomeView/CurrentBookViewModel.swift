//
//  HomeViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

final class CurrentBookViewModel {
    
    @Published var currentBookProgress: BookProgress?
    @Published var currentBook: Book?
    
    
    func refresh() {
        //TODO: get current book progress from db
        self.currentBookProgress = BookProgress(name: "Chinese 1", progress: "0/10")
        self.currentBook = Book(id: "1", category_id: "1", name: "Chinese 1")
    }
}
