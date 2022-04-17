//
//  SampleDataUtilities.swift
//  LingoClash
//
//  Created by Kyle キラ on 1/4/22.
//

import Foundation
import PromiseKit

enum SampleDataError: Error {
    case parseError
}

class SampleDataUtilities {

    static func createSampleData() -> Promise<Void> {
        let authProvider = AppConfigs.API.authProvider

        return authProvider.login(
            params: LoginFields(
                email: "superuser@lingoclash.com",
                password: "iamsuperuser")).then {_ -> Promise<Void> in

                    Logger.info("Successfully logged in as superuser. Creating sample data now...")

                    let categoryPromise = createSampleBookCategories()
                    let bookPromise = createSampleBooks()
                    let lessonPromise = createSampleLessons()
                    let vocabPromise = createSampleVocabs()

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

    private static func createSampleBooks() -> Promise<Void> {
        Logger.info("Creating sample books...")

        let languageLevelNames = ["TOPIK ", "JLPT N", "HSK "]

        let bookManager = BookManager()
        var books = [BookData]()
        var bookId = 0

        for i in 0...2 {
            for j in 0...2 {
                let book = BookData(
                    id: String(bookId),
                    category_id: String(i),
                    name: "\(languageLevelNames[i])\(j + 1)")
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

        let categoryNames = ["Korean", "Japanese", "Chinese"]

        let bookCategoryManager = BookCategoryManager()
        var categories = [BookCategoryData]()
        for i in 0...2 {
            let category = BookCategoryData(id: String(i), name: categoryNames[i])
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

        for i in 0...8 {
            for j in 0...9 {
                let lesson = LessonData(
                    id: String(lessonId),
                    name: "Lesson \(j + 1)",
                    book_id: String(i)
                )
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

        guard let vocabItems = parseKoreanJSON() else {
            return Promise.reject(reason: SampleDataError.parseError)
        }

        var vocabId = 0
        var lessonId = 0

        let vocabsData = vocabItems.map { vocab -> VocabData in

            let definitionItem = vocab.defs?[0]
            let exampleItem = definitionItem?.examples?[0]

            let vocabData = VocabData(
                id: String(vocabId),
                definition: definitionItem?.def ?? "No definition available",
                lesson_id: String(lessonId),
                sentence: exampleItem?.example ?? "No example available",
                word: vocab.word,
                translation: exampleItem?.translation ?? "No translation available",
                pronunciation_text: vocab.romaja ?? ""
            )

            vocabId += 1
            if vocabId.isMultiple(of: 5) {
                lessonId += 1
            }

            return vocabData
        }

        return vocabManager.createMany(newRecords: vocabsData).done {_ in
            Logger.info("Sample vocabs successfully created!")
        }
    }

    private static func parseKoreanJSON() -> [VocabItem]? {
        guard let path = Bundle.main.path(forResource: "korean-eng", ofType: "json") else {
            return nil
        }

        let url = URL(fileURLWithPath: path)

        var result: [VocabItem]?
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode([VocabItem].self, from: jsonData)
        } catch {
            Logger.error("Error parsing: \(error)")
        }

        return result
    }

}

struct VocabItem: Codable {
    let word: String
    let romaja: String?
    let pos: String
    let defs: [DefinitionItem]?
}

struct DefinitionItem: Codable {
    let def: String
    let examples: [ExampleItem]?
}

struct ExampleItem: Codable {
    let example: String
    let transliteration: String?
    let translation: String?
}
