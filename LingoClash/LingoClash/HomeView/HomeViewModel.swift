//
//  HomeViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 8/4/22.
//

import Combine
import PromiseKit

class HomeViewModel {
    @Published var isRefreshing = false
    @Published var profile: Profile?
    @Published var currentBook: Book?
    @Published var lessonSelectionViewModel: LessonSelectionViewModel?
    
    private let profileManager = ProfileManager()
    
    func refresh() {
        self.isRefreshing = true
        firstly {
            profileManager.getCurrentProfile()
        }.done { profile in
            self.profile = profile
            self.currentBook = profile.currentBook
            if let book = profile.currentBook {
                self.lessonSelectionViewModel = LessonSelectionViewModelFromBook(book: book)
            }
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }
    }
}

