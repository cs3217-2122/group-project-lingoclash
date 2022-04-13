//
//  SampleDataUtilities.swift
//  LingoClash
//
//  Created by Kyle キラ on 1/4/22.
//

import Foundation
import PromiseKit


class SampleDataUtilities {
    
    static func createSampleData() -> Promise<Void> {
        let authProvider = AppConfigs.API.authProvider
                
        return authProvider.login(params: LoginFields(email: "superuser@lingoclash.com", password: "iamsuperuser")).then {_ -> Promise<Void> in
            
            Logger.info("Successfully logged in as superuser. Creating sample data now...")
            
            let categoryPromise = createSampleBookCategories()
            let bookPromise = createSampleBooks()
            let lessonPromise = createSampleLessons()
            let vocabPromise =  createSampleVocabs()
            
            return when(fulfilled: [
                categoryPromise,
                bookPromise,
                lessonPromise,
                vocabPromise
            ]).then { () -> Promise<Void> in
                Logger.info("All sample data is successfully created!")
                return authProvider.logout()
            }
        }
    }
    
    // TODO: add book icon
    private static func createSampleBooks() -> Promise<Void> {
        Logger.info("Creating sample books...")
        
        let bookManager = BookManager()
        var books = [BookData]()
        var bookId = 0
        
        for i in 0...5 {
            for j in 0...5 {
                let book = BookData(id: String(bookId), category_id: String(i), name: "Book \(i)-\(j)")
                books.append(book)
                bookId += 1
            }
        }
        
        return bookManager.createMany(newRecords: books).done {_ in
            Logger.info("Sample books successfully created!")
        }
    }
    
    private static func createSampleBookCategories() -> Promise<Void> {
        Logger.info("Creating sample book categories...")
        
        let bookCategoryManager = BookCategoryManager()
        var categories = [BookCategoryData]()
        for i in 0...5 {
            let category = BookCategoryData(id: String(i), name: "Language - \(i)")
            categories.append(category)
        }
        
        return bookCategoryManager.createMany(newRecords: categories).done {_ in
            Logger.info("Sample book categories successfully created!")
        }
    }
    
    private static func createSampleLessons() -> Promise<Void> {
        Logger.info("Creating sample lessons...")
        
        let lessonManager = LessonManager()
        var lessons = [LessonData]()
        var lessonId = 0
        
        for i in 0...35 {
            for j in 0...9 {
                let lesson = LessonData(
                    id: String(lessonId), name: "Lesson \(j)", book_id: String(i))
                lessons.append(lesson)
                lessonId += 1
            }
        }
        
        return lessonManager.createMany(newRecords: lessons).done {_ in
            Logger.info("Sample lessons successfully created!")
        }
    }
    
    private static func createSampleVocabs() -> Promise<Void> {
        Logger.info("Creating sample vocabs...")
        
        let vocabManager = VocabManager()
        var vocabs = [VocabData]()
        var vocabId = 0
        
        for i in 0...30 {
            for j in 0...9 {
                let vocab = VocabData(id: String(vocabId), definition: "Definition of vocab \(j)", lesson_id: String(i), sentence: "Example sentence of vocab \(j)", word: "Vocabulary - \(vocabId)")
                vocabs.append(vocab)
                vocabId += 1
            }
        }
        
        return vocabManager.createMany(newRecords: vocabs).done {_ in
            Logger.info("Sample vocabs successfully created!")
        }
    }
    
}
