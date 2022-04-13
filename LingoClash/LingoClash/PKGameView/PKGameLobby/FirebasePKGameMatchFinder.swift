//
//  FirebaseMultiplayerMatchFinder.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//
import PromiseKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebasePKGameMatchFinder: PKGameMatchFinder {
    enum FirebaseMultiplayerMatchFinderError: Error {
        case invalidQuerySnapshot
        case invalidDocumentSnapshot
        case emptyDocument
        case questionGenerationError
        case noCurrentBook
    }
    
    private let db = Firestore.firestore()
    private let queueCollection = "queueEntries"
    private let gameType = "PKGame"
    private let bookDataManager = BookManager()
    private let queueEntryDataManager = QueueEntryDataManager()
    private let pkGameDataManager = PKGameDataManager()
    func findGame(playerProfile: Profile) -> Promise<PKGame> {
        return firstly {
            getValidQueueEntries(playerProfile: playerProfile)
        }.then { [self] queueEntries -> Promise<PKGame> in
            if queueEntries.count < PKGame.playerCountRequired - 1 {
                return self.joinQueue(playerProfile: playerProfile)
            } else {
                return self.createGame(playerProfile: playerProfile, queueEntries: queueEntries)
            }
        }
    }
    
    private func createGame(playerProfile: Profile, queueEntries: [QueueEntry]) -> Promise<PKGame> {
        //    5. Get first minRequired number of queueEntries
        let queueEntries = queueEntries.prefix(PKGame.playerCountRequired)
        var players = queueEntries.map { $0.playerProfile }
        players.append(playerProfile)
        
        // Generate questions from question generator
        // TODO: Replace with actaul BookDataManager
        let bookVocabs: [Vocab] = [
            Vocab(word: "周", definition: "week", sentence: "一周有七天。",
                      sentenceDefinition: "Every week has 7 days.", pronunciationText: "zhōu"),
            Vocab(word: "今天", definition: "today", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(word: "明天", definition: "tomorrow", sentence: "明天10：10",
                      sentenceDefinition: " tomorrow at 10:10", pronunciationText: "míngtiān"),
            Vocab(word: "昨天", definition: "yesterday", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(word: "日历", definition: "calendar", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(word: "秒", definition: "second", sentence: "她今天看起来很悲伤。",
                      sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān")
        ]
        let questionsInScope = generateQuestions(vocabs: bookVocabs)
        guard let questionsInScope = questionsInScope else {
            return Promise.reject(reason: FirebaseMultiplayerMatchFinderError.questionGenerationError)
        }
        let pkGame = PKGame(createdAt: Date.now, players: players, questions: questionsInScope)
        return firstly {
            pkGameDataManager.create(newRecord: pkGame)
        }.then { [self] newGame -> Promise<PKGame> in
            let batch = self.db.batch()
            
            for id in queueEntries.map({ $0.id }) {
                let docRef = db.collection("queueEntries").document(id)
                let fieldsToUpdate = [
                    "gameId": newGame.id,
                    "isWaiting": false
                ] as [String : Any]
                batch.updateData(fieldsToUpdate, forDocument: docRef)
            }
            
            return Promise { seal in
                batch.commit() { error in
                    if let error = error {
                        print(error)
                        return seal.reject(error)
                    }
                    
                    return seal.fulfill(newGame)
                }
            }
        }
    }
    
    private func joinQueue(playerProfile: Profile) -> Promise<PKGame> {
        // 1. create queue entry
        let newQueueEntry = QueueEntry(id: "", playerProfile: playerProfile, joinedAt: Date.now, isWaiting: true, gameType: gameType)

        let promise = firstly {
            queueEntryDataManager.create(newRecord: newQueueEntry)
        }.then { [self] newQueueEntry in
            self.listenForGameCreation(newQueueEntry)
        }
        return promise
    }
    
    private func generateQuestions(vocabs: [Vocab]) -> [Question]? {
        let questionGenerator = QuestionsGenerator()
        
        guard var questionSequence = try? questionGenerator.generateQuestions(settings: QuestionGeneratorSettings(scope: Set(vocabs))) else {
            return nil
        }
        
        let questions = (0..<PKGame.numberOfQuestions).compactMap { _ in
            questionSequence.next()
        }
        
        return questions
    }
    
    private func listenForGameCreation(_ queueEntry: QueueEntry) -> Promise<PKGame> {
        // 1. add a listener to the queue entry, the callback function passed to the listener will call seal.accept(with the game after gameId is filled)
        // 2. getOne the PKGame that corresponds to the gameId
        return Promise<Identifier> { seal in
            self.db.collection("queueEntries").document(queueEntry.id).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    return seal.reject(FirebaseMultiplayerMatchFinderError.invalidDocumentSnapshot)
                }
                guard let data = document.data() else {
                    return
                }
                
                if let gameId = data["gameId"] {
                    guard let gameId = gameId as? Identifier else {
                        return seal.reject(FirebaseMultiplayerMatchFinderError.invalidDocumentSnapshot)
                    }
                    return seal.fulfill(gameId)
                }
            }
        }.then { gameId in
            self.pkGameDataManager.getOne(id: gameId)
        }
    }
        
    private func getValidQueueEntries(playerProfile: Profile) -> Promise<[QueueEntry]> {
        //    1. Find all queueEntries that have:
        //        a. Same game type
        //        b. isWaiting is true
        //        c. Different playerId
        //        d. Overlap in playerScope
        guard let currenBookId = playerProfile.currentBook?.id else {
            return Promise.reject(reason: FirebaseMultiplayerMatchFinderError.noCurrentBook)
        }
        let filters: [String: Any] = [
            "gameType": self.gameType,
            "isWaiting": true,
            "playerProfile.currentBookId": currenBookId
        ]
        return queueEntryDataManager.getList(field: "joinedAt", isDescending: false, filter: filters)
    }
}
