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
    private var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    private let gameType = DataManagerResources.pkGames
    private let bookDataManager = BookManager()
    private let questionsGenerator = QuestionsGenerator()
    private let queueEntryDataManager = QueueEntryDataManager()
    private let pkGameDataManager = PKGameManager()
    private let profileDataManager = ProfileManager()
    func findGame(playerProfile: Profile) -> Promise<PKGame> {
        firstly {
            getValidQueueEntries(playerProfile: playerProfile)
        }.then { [self] queueEntries -> Promise<PKGame> in
            if queueEntries.count < PKGame.playerCountRequired - 1 {
                return self.joinQueue(playerProfile: playerProfile)
            } else {
                return self.createGame(playerProfile: playerProfile, queueEntries: queueEntries)
            }
        }
    }

    func cancel(playerProfile: Profile) {
        // If queue entry exists belonging to playerProfile that is currently waiting, remove it
        let filters: [String: Any] = [
            "gameType": self.gameType,
            "isWaiting": true,
            "playerProfile.id": playerProfile.id
        ]

        _ = queueEntryDataManager.getList(filter: filters)
            .then { [self] queueEntriesToDelete -> Promise<[Identifier]> in
                assert(!queueEntriesToDelete.isEmpty)
                return self.queueEntryDataManager.deleteMany(ids: queueEntriesToDelete.map { $0.id })
            }.done { _ in
                self.listener = nil
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
        let queueEntries = queueEntryDataManager.getList(field: "joinedAt", isDescending: false, filter: filters)
        let filteredQueueEntries = queueEntries.map { queueEntries in
            queueEntries.filter { $0.playerProfile.id != playerProfile.id }
        }
        return filteredQueueEntries
    }

    private func createGame(playerProfile: Profile, queueEntries: [QueueEntry]) -> Promise<PKGame> {
        firstly {
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
                ] as [String: Any]
                batch.updateData(fieldsToUpdate, forDocument: docRef)
            }

            return Promise { seal in
                batch.commit { error in
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
        firstly { () -> Promise<ProfileData> in
            let currentPlayerProfileData = profileDataManager.getOne(id: playerProfile.id)
            return currentPlayerProfileData
        }.then { [self] currentPlayerProfileData -> Promise<QueueEntry> in
            let newQueueEntry = QueueEntry(
                id: "",
                playerProfile: currentPlayerProfileData,
                joinedAt: Date.now,
                isWaiting: true,
                gameType: gameType)

            return self.queueEntryDataManager.create(newRecord: newQueueEntry)
        }.then { [self] newQueueEntry in
            self.listenForGameCreation(newQueueEntry)
        }
    }
}

// MARK: Helper methods for joinQueue
extension FirebasePKGameMatchFinder {
    private func listenForGameCreation(_ queueEntry: QueueEntry) -> Promise<PKGame> {
        Promise<Identifier> { seal in
            self.listener = self.db.collection(
                DataManagerResources.queueEntries).document(queueEntry.id).addSnapshotListener { documentSnapshot, _ in
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
        }.then { gameId -> Promise<PKGame> in
            self.listener = nil
            return self.pkGameDataManager.getPKGame(id: gameId)
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

        let gamePlayersProfile = generateGamePlayersProfileData(
            queueEntries: queueEntries,
            currentPlayerProfile: playerProfile)
        let pkGameData = gamePlayersProfile.map { gamePlayersData -> PKGameData in
            PKGameData(createdAt: Date.now, players: gamePlayersData, questions: questionsInScope)
        }

        return pkGameData
    }

    private func generateGamePlayersProfileData(queueEntries: [QueueEntry],
                                                currentPlayerProfile: Profile) -> Promise<[ProfileData]> {
        firstly {
            profileDataManager.getOne(id: currentPlayerProfile.id)
        }.map { currentPlayerProfileData -> [ProfileData] in
            let gameQueueEntries = queueEntries.prefix(PKGame.playerCountRequired - 1)
            var players = gameQueueEntries.map { $0.playerProfile }
            players.append(currentPlayerProfileData)
            return players
        }
    }

    private func generateQuestions(playerProfile: Profile) -> [Question]? {
        guard let currentBook = playerProfile.currentBook else {
            return nil
        }
        let bookVocabs = currentBook.getVocabs()

        guard var questionSequence = try? questionsGenerator.generateQuestions(
            settings: QuestionGeneratorSettings(
                scope: bookVocabs)) else {
            return nil
        }

        let questions = (0..<PKGame.numberOfQuestions).compactMap { _ in
            questionSequence.next() as? Question
        }

        return questions
    }
}
