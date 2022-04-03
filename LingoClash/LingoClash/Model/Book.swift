//
//  Book.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct BookCategory {
    let id: Identifier
    let name: String
}

struct Lesson {
    let id: Identifier
    let vocabs: [Vocab]
    let stars: Int
    let name: String
    
    var questions = [Question]()
    var didPass: Bool {
        stars > 0
    }
}

struct Book {
    let id: Identifier
    let category: BookCategory
    let name: String
    let isCompleted: Bool
    let totalLessons: Int
    let passedLessons: Int
    let lessons: [Lesson]
    var progress: String {
        "\(passedLessons) / \(totalLessons)"
    }
}
