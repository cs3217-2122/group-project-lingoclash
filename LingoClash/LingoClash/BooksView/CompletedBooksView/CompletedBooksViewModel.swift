//
//  CompletedBooksViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import Combine
import PromiseKit

final class CompletedBooksViewModel: BooksViewModel {
    
    @Published var error: String?
    @Published var booksProgress: [BookProgress] = []
    var booksProgressPublisher: Published<[BookProgress]>.Publisher {
        $booksProgress
    }
    
    private let authProvider: AuthProvider
    private let profileDataManager = ProfileManager()
    private let profileBookDataManager = ProfileBookManager()
    private let bookDataManager = BookManager()
    
    init(authProvider: AuthProvider = AppConfigs.API.authProvider) {
        self.authProvider = authProvider
    }
    
    func refreshBooks() {
        // TODO: Call firebase API to get books the user has completed
//        booksProgress = [BookProgress(name: "Korean 1", progress: "10/10"),
//                         BookProgress(name: "Korean 2", progress: "10/10"),
//                         BookProgress(name: "Japanese 1", progress: "10/10")]
        
        print("kw0")
        
        firstly {
            BookManager().getLearningBooks()
        }.done { books in
            print("kw1", books)
        }
        
    }
}

