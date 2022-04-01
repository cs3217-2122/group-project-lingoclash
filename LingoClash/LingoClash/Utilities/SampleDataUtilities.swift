//
//  SampleDataUtilities.swift
//  LingoClash
//
//  Created by Kyle キラ on 1/4/22.
//

import Foundation
import PromiseKit


class SampleDataUtilities {
    
    static func createSampleData() {
        createSampleUsers()
        createSampleProfiles()
        createSampleBookCategories()
        createSampleBooks()
        createSampleLessons()
        createSampleVocabs()
        createSampleProfileBooks()
    }
    
    private static func createSampleBooks() {
        Logger.info("Creating sample books...")
        
        let bookManager = BookManager()
        var books = [Book]()
        
        var bookId = 0
        
        for i in 0...5 {
            for j in 0...5 {
                let book = Book(id: String(bookId), category_id: String(i), name: "Book \(i)-\(j)")
                books.append(book)
                bookId += 1
            }
        }
        
        let _ = bookManager.createMany(newRecords: books).done {_ in
            Logger.info("Sample books successfully created!")
        }
    }
    
    private static func createSampleBookCategories() {
        Logger.info("Creating sample book categories...")
        
        let bookCategoryManager = BookCategoryManager()
        var categories = [BookCategory]()
        for i in 0...5 {
            let category = BookCategory(id: String(i), name: "Language - \(i)")
            categories.append(category)
        }
        
        let _ = bookCategoryManager.createMany(newRecords: categories).done {_ in 
            Logger.info("Sample book categories successfully created!")
        }
    }
    
    private static func createSampleLessons() {
        Logger.info("Creating sample lessons...")
        
        let lessonManager = LessonManager()
        var lessons = [Lesson]()
        
        var lessonId = 0
        
        for i in 0...35 {
            for _ in 0...9 {
                let lesson = Lesson(id: String(lessonId), book_id: String(i))
                lessons.append(lesson)
                lessonId += 1
            }
        }
        
        let _ = lessonManager.createMany(newRecords: lessons).done {_ in
            Logger.info("Sample lessons successfully created!")
        }
    }
    
    private static func createSampleVocabs() {
        Logger.info("Creating sample vocabs...")
        
        let vocabManager = VocabManager()
        var vocabs = [Vocab]()
        
        var vocabId = 0
        
        for i in 0...30 {
            for j in 0...9 {
                let vocab = Vocab(id: String(vocabId), definition: "Definition of vocab \(j)", lesson_id: String(i), sentence: "Example sentence of vocab \(j)", word: "Vocabulary - \(vocabId)")
                vocabs.append(vocab)
                vocabId += 1
            }
        }
        
        let _ = vocabManager.createMany(newRecords: vocabs).done {_ in
            Logger.info("Sample vocabs successfully created!")
        }
    }
    
    private static func createSampleUsers() {
        // TODO: Create test account using AuthProvider::register
    }
    
    private static func createSampleProfiles() {
        
    }
    
    private static func createSampleProfileBooks() {
        
    }
    
}
