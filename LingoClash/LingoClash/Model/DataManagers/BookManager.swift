//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 22/3/22.
//

import PromiseKit

// TODO: move to own file
enum DataManagerError: Error {
    case dataNotFound
}

class BookManager: DataManager<BookData> {
    
    init() {
        super.init(resource: "books")
    }
    
    func getBook(id: Identifier) -> Promise<Book> {
        var book: BookData?
        var bookCategory: BookCategoryData?
        var profileBook: ProfileBookData?
        var vocabsByLesson = [LessonData: [VocabData]]()
        
        return firstly {
            return firstly {
                self.getOne(id: id)
            }.done { bookData in
                book = bookData
            }
        }.then { () -> Promise<Void> in
            // Gets the lessons of the book
            guard let book = book else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }

            return firstly {
                LessonManager().getManyReference(target: "book_id", id: book.id)
            }.then { lessons -> Promise<Void> in
                // Gets the vocabs of the lesson
                let vocabManager = VocabManager()
                let vocabsPromises = lessons.map { lessonData in
                    firstly {
                        vocabManager.getManyReference(target: "lesson_id", id: lessonData.id)
                    }.done { vocabData in
                        vocabsByLesson[lessonData] = vocabData
                    }
                }
                return when(fulfilled: vocabsPromises)
            }
        }.then { () -> Promise<Void> in
            // Gets the book category
            guard let categoryId = book?.category_id else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }

            return firstly {
                BookCategoryManager().getOne(id: categoryId)
            }.done { bookCategoryData in
                bookCategory = bookCategoryData
            }
        }.then { () -> Promise<Void> in
            // Gets the profile book
            return firstly {
                ProfileBookManager().getManyReference(target: "book_id", id: id)
            }.done { profileBooksData in
                guard !profileBooksData.isEmpty else {
                    return
                }

                profileBook = profileBooksData[0]
            }
        }.compactMap {
            guard let book = book,
                    let bookCategory = bookCategory,
                    let profileBook = profileBook else {
                return nil
            }

            return Book(
                bookData: book,
                vocabsByLesson: vocabsByLesson,
                bookCategoryData: bookCategory,
                profileBookData: profileBook)
        }
        
    }
    
    func getCompletedBooks() {
        
        
        
    }
}
