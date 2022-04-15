//
//  BookCategory.swift
//  LingoClash
//
//  Created by Kyle キラ on 4/4/22.
//

import Foundation

struct BookCategory {
    let id: Identifier
    let name: String

    init(bookCategoryData: BookCategoryData) {
        self.id = bookCategoryData.id
        self.name = bookCategoryData.name
    }
}
