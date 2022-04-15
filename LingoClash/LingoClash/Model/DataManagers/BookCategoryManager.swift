//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 22/3/22.
//

class BookCategoryManager: DataManager<BookCategoryData> {

    init() {
        super.init(resource: DataManagerResources.bookCategories)
    }
}
