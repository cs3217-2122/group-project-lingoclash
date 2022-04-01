//
//  Book.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

struct Book {
    var id: Identifier
    let category_id: Identifier
    let name: String
}

extension Book: Record {}
