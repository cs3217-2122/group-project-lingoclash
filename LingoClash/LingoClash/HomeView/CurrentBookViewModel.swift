//
//  HomeViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine

final class CurrentBookViewModel {
    
    @Published var currentBookProgress: BookProgress?
    
    func refresh() {
        //TODO: get current book progress from db
        self.currentBookProgress = BookProgress(name: "Korean 3", progress: "1/10")
    }
}

