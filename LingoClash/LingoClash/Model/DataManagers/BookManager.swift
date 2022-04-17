//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 22/3/22.
//

import PromiseKit

class BookManager: DataManager<BookData> {

    init() {
        super.init(resource: DataManagerResources.books)
    }

    func getBook(id: Identifier) -> Promise<Book> {
        var book: BookData?
        var bookCategory: BookCategoryData?
        var profileBook: ProfileBookData?
        var profileLessons = [ProfileLessonData]()
        var vocabsByLesson = [LessonData: [VocabData]]()

        return firstly {
            firstly {
                self.getOne(id: id)
            }.done { bookData in
                book = bookData
            }
        }.then { () -> Promise<Void> in
            guard let book = book else {
                return Promise.reject(reason: DataManagerError.dataNotFound)
            }

            // Gets the lessons of the book
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
                if !profileBooksData.isEmpty {
                    profileBook = profileBooksData[0]
                }
            }
        }.then { () -> Promise<Void> in
            guard let profileBook = profileBook else {
                return Promise<Void>()
            }

            // Gets the profile lessons
            return firstly {
                ProfileLessonManager().getManyReference(target: "profile_book_id", id: profileBook.id)
            }.done { profileLessonData in
                guard !profileLessonData.isEmpty else {
                    return
                }

                profileLessons = profileLessonData
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
                profileBookData: profileBook,
                profileLessonsData: profileLessons
            )
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

    func getRecommendedBooks() -> Promise<[BooksForCategory]> {
        var recommendedBooks = [Book]()
        var bookCategories = [BookCategoryData]()
        var booksForCategories = [BooksForCategory]()

        return firstly {
            self.getList()
        }.then { booksData -> Promise<Void> in
            // Gets all books
            let bookPromises = booksData.map { bookData in
                firstly {
                    self.getBook(id: bookData.id)
                }.done { book in
                    recommendedBooks.append(book)
                }
            }

            return when(fulfilled: bookPromises)
        }.then { () -> Promise<Void> in
            // Gets the book category
            firstly {
                BookCategoryManager().getList()
            }.done { bookCategoryData in
                bookCategories = bookCategoryData
            }
        }.map {
            // Groups books by category name
            for category in bookCategories {
                let books = recommendedBooks.filter { book in
                    book.status == .unread && book.category.name == category.name
                }

                if books.count == 0 {
                    continue
                }

                let booksForCategory = BooksForCategory(category: category.name, books: books)
                booksForCategories.append(booksForCategory)
            }
            return booksForCategories
        }
    }

    func markAsLearning(bookId: Identifier) -> Promise<ProfileBookData> {
        firstly {
            ProfileManager().setAsCurrentBook(bookId: bookId)
        }.then { currentProfile in
            ProfileBookManager().create(
                newRecord: ProfileBookData(
                    id: "-1",
                    profile_id: currentProfile.id,
                    book_id: bookId, is_completed: false))
        }
    }
}
