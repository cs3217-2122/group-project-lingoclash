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
    private let gameType = DataManagerResources.pkGames
    private let bookDataManager = BookManager()
    private let questionsGenerator = QuestionsGenerator()
    private let queueEntryDataManager = QueueEntryDataManager()
    private let pkGameDataManager = PKGameManager()
    private let profileDataManager = ProfileManager()
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
    
    private func getValidQueueEntries(playerProfile: Profile) -> Promise<[QueueEntry]> {
        //    1. Find all queueEntries that have:
        //        a. Same game type
        //        b. isWaiting is true
        //        c. Different playerId
        //        d. Overlap in playerScope
        guard let currentBookId = playerProfile.currentBook?.id else {
            return Promise.reject(reason: FirebaseMultiplayerMatchFinderError.noCurrentBook)
        }
        let filters: [String: Any] = [
            "gameType": self.gameType,
            "isWaiting": true,
            "playerProfile.book_id": currentBookId
        ]
        return queueEntryDataManager.getList(field: "joinedAt", isDescending: false, filter: filters)
    }
    
    private func createGame(playerProfile: Profile, queueEntries: [QueueEntry]) -> Promise<PKGame> {
        return firstly {
            generatePKGameData(playerProfile: playerProfile, queueEntries: queueEntries)
        }.then { [self] pkGameData in
            self.pkGameDataManager.createPKGame(pkGameData: pkGameData)
        }.then { [self] newGame -> Promise<PKGame> in
            let batch = self.db.batch()
            for id in queueEntries.map({ $0.id }) {
                let docRef = db.collection(DataManagerResources.queueEntries).document(id)
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
        return firstly { () -> Promise<ProfileData> in
            let currentPlayerProfileData = profileDataManager.getOne(id: playerProfile.id)
            return currentPlayerProfileData
        }.then { [self] currentPlayerProfileData -> Promise<QueueEntry> in
            let newQueueEntry = QueueEntry(id: "", playerProfile: currentPlayerProfileData, joinedAt: Date.now, isWaiting: true, gameType: gameType)

            return self.queueEntryDataManager.create(newRecord: newQueueEntry)
        }.then { [self] newQueueEntry in
            self.listenForGameCreation(newQueueEntry)
        }
    }
}

// MARK: Helper methods for joinQueue
extension FirebasePKGameMatchFinder {
    private func listenForGameCreation(_ queueEntry: QueueEntry) -> Promise<PKGame> {
        // 1. add a listener to the queue entry, the callback function passed to the listener will call seal.accept(with the game after gameId is filled)
        // 2. getOne the PKGame that corresponds to the gameId

        // TODO: This is firebase query inefficient since every player has to do the query chain of PKGame -> Profiles -> Books -> Lessons -> Vocabs
        return Promise<Identifier> { seal in
            self.db.collection(DataManagerResources.queueEntries).document(queueEntry.id).addSnapshotListener { documentSnapshot, error in
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
            self.pkGameDataManager.getPKGame(id: gameId)
        }
    }
}

// MARK: Helper methods for createGame
extension FirebasePKGameMatchFinder {
    private func generatePKGameData(playerProfile: Profile, queueEntries: [QueueEntry]) -> Promise<PKGameData> {
        let questionsInScope = generateQuestions(playerProfile: playerProfile)
        
        guard let questionsInScope = questionsInScope else {
            return Promise.reject(reason: FirebaseMultiplayerMatchFinderError.questionGenerationError)
        }
        
        let gamePlayersProfile = generateGamePlayersProfileData(queueEntries: queueEntries, currentPlayerProfile: playerProfile)
        let pkGameData = gamePlayersProfile.map { gamePlayersData -> PKGameData in
            PKGameData(createdAt: Date.now, players: gamePlayersData, questions: questionsInScope)
        }
        
        return pkGameData
    }
    
    private func generateGamePlayersProfileData(queueEntries: [QueueEntry], currentPlayerProfile: Profile) -> Promise<[ProfileData]> {
        return firstly {
            profileDataManager.getOne(id: currentPlayerProfile.id)
        }.map { currentPlayerProfileData -> [ProfileData] in
            let gameQueueEntries = queueEntries.prefix(PKGame.playerCountRequired)
            var players = gameQueueEntries.map { $0.playerProfile }
            players.append(currentPlayerProfileData)
            return players
        }
    }
    
    private func generateQuestions(playerProfile: Profile) -> [Question]? {
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
        
        let vocabs = bookVocabs
        
        guard var questionSequence = try? questionsGenerator.generateQuestions(settings: QuestionGeneratorSettings(scope: Set(vocabs))) else {
            return nil
        }
        
        let questions = (0..<PKGame.numberOfQuestions).compactMap { _ in
            questionSequence.next()
        }
        
        return questions
    }
}
