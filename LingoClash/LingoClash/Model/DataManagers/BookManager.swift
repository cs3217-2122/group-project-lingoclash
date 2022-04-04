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
            firstly {
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
                let vocabsPromises = lessons.map { lessonData in
                    firstly {
                        VocabManager().getManyReference(target: "lesson_id", id: lessonData.id)
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
            firstly {
                ProfileBookManager().getManyReference(target: "book_id", id: id)
            }.done { profileBooksData in
                guard !profileBooksData.isEmpty else {
                    return
                }

                profileBook = profileBooksData[0]
            }
        }.compactMap {
            guard let book = book,
                    let bookCategory = bookCategory else {
                return nil
            }

            return Book(
                bookData: book,
                vocabsByLesson: vocabsByLesson,
                bookCategoryData: bookCategory,
                profileBookData: profileBook)
        }
        
    }
    
    func getBook(book: BookData) -> Promise<Book> {
        var bookCategory: BookCategoryData?
        var profileBook: ProfileBookData?
        var vocabsByLesson = [LessonData: [VocabData]]()
        
        return firstly {
            // Gets the lessons of the book
            firstly {
                LessonManager().getManyReference(target: "book_id", id: book.id)
            }.then { lessons -> Promise<Void> in
                // Gets the vocabs of the lesson
                let vocabsPromises = lessons.map { lessonData in
                    firstly {
                        VocabManager().getManyReference(target: "lesson_id", id: lessonData.id)
                    }.done { vocabData in
                        vocabsByLesson[lessonData] = vocabData
                    }
                }
                return when(fulfilled: vocabsPromises)
            }
        }.then { () -> Promise<Void> in
            // Gets the book category
            firstly {
                BookCategoryManager().getOne(id: book.category_id)
            }.done { bookCategoryData in
                bookCategory = bookCategoryData
            }
        }.then { () -> Promise<Void> in
            // Gets the profile book
            firstly {
                ProfileBookManager().getManyReference(
                    target: "book_id", id: book.id)
            }.done { profileBooksData in
                guard !profileBooksData.isEmpty else {
                    return
                }

                profileBook = profileBooksData[0]
            }
        }.compactMap {
            guard let bookCategory = bookCategory else {
                return nil
            }

            return Book(
                bookData: book,
                vocabsByLesson: vocabsByLesson,
                bookCategoryData: bookCategory,
                profileBookData: profileBook)
        }
        
    }
    
    func getCompletedBooks() -> Promise<[Book]> {
        var completedBooks = [Book]()
        
        return firstly {
            ProfileManager().getCurrentProfile()
        }.then { profileData in
            // Gets the filtered profile books
            ProfileBookManager().getManyReference(
                target: "profile_id", id: profileData.id, filter: ["is_completed": true])
        }.then { profileBooksData -> Promise<Void> in
            // Gets the books
            let bookPromises = profileBooksData.map { profileBookData in
                firstly {
                    self.getBook(id: profileBookData.book_id)
                }.done { book in
                    completedBooks.append(book)
                }
            }
            
            return when(fulfilled: bookPromises)
        }.map {
            completedBooks
        }
    }
    
    func getLearningBooks() -> Promise<[Book]> {
        var learningBooks = [Book]()
        
        return firstly {
            ProfileManager().getCurrentProfile()
        }.then { profileData in
            // Gets the filtered profile books
            ProfileBookManager().getManyReference(
                target: "profile_id", id: profileData.id, filter: ["is_completed": false])
        }.then { profileBooksData -> Promise<Void> in
            // Gets the books
            let bookPromises = profileBooksData.map { profileBookData in
                firstly {
                    self.getBook(id: profileBookData.book_id)
                }.done { book in
                    learningBooks.append(book)
                }
            }
            
            return when(fulfilled: bookPromises)
        }.map {
            learningBooks
        }
    }
    
    func getRecommendedBooks() -> Promise<[Book]> {
        var recommendedBooks = [Book]()
        
        return firstly {
            self.getList()
        }.then { booksData -> Promise<Void> in
            let bookPromises = booksData.map { bookData in
                firstly {
                    self.getBook(id: bookData.id)
                }.done { book in
                    recommendedBooks.append(book)
                }
            }
            
            return when(fulfilled: bookPromises)
        }.map {
            recommendedBooks
        }
    }
    
    func markAsLearning(bookId: Identifier) -> Promise<ProfileBookData> {
        firstly {
            ProfileManager().getCurrentProfile()
        }.then { currentProfile in
            ProfileBookManager().create(
                newRecord: ProfileBookData(
                    id: "-1",
                    profile_id: currentProfile.id,
                    book_id: bookId, is_completed: false, profile_lessons: []))
        }
    }
}
