//
//  FirebasePKGameMoveUpdater.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//
import PromiseKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebasePKGameUpdater: PKGameUpdateDelegate {

    enum FirebasePKGameUpdaterError: Error {
        case errorUpdatingForfeit(desc: String)
    }
    // TODO: abstract this away into a general synchroniser class

    private let db = Firestore.firestore()
    private let profileManager = ProfileManager()
    private let pkGameManager = PKGameManager()
    private let pkGameOutcomeManager = PKGamePlayerOutcomeManager()

    private let moveCollectionRef: CollectionReference
    private let gameDocumentRef: DocumentReference

    // All listeners on fields of pkGame
    private var pkGameUpdateListeners: [(PKGameUpdateListener, PKGameData) -> Void] = []
    private let pkGame: PKGame
    var firebaseMoveListeners: [ListenerRegistration] = []

    var gameUpdateListener: PKGameUpdateListener? {
        didSet {
            removeListeners()
            if let moveListener = gameUpdateListener {
                addListenerToMoves(gameUpdateListener: moveListener)
                addListenerToPKGame(gameUpdateListener: moveListener)
            }
        }
    }

    init(game: PKGame) {
        self.pkGame = game
        self.gameDocumentRef = db.collection(DataManagerResources.pkGames).document(game.id)
        self.moveCollectionRef = self.gameDocumentRef.collection(DataManagerResources.pkGamesMoves)
        self.pkGameUpdateListeners = [updateListenerOnForfeit]
    }

    func didCompleteGame(outcome: PKGamePlayerOutcome) {
        let outcomeData = PKGamePlayerOutcomeData(gameId: pkGame.id, gamePlayerOutcome: outcome)
        _ = self.pkGameOutcomeManager.create(newRecord: outcomeData)
    }

    func didForfeit(player: Profile) {
        print("did forfeit game")
        Promise<Profile> { seal in
            // TODO: Add method in firebase to support this (Repeated issue where dataprovider methods are not specific enough)
            // Alternative is less efficient: Query to get the existing PKGameData then update it
            self.gameDocumentRef.updateData([
                "forfeittedPlayers": FieldValue.arrayUnion([player.id])
            ]) { err in
                if let err = err {
                    return seal.reject(FirebasePKGameUpdaterError
                        .errorUpdatingForfeit(
                            desc: "\(err): Error adding forfeitted player to Firebase \(player.id) \(player.name)"))
                }
                print("Successfully added forfietted player to Firebase \(player.id) \(player.name)")
                return seal.fulfill(player)
            }
        }.catch { err in
            print(err)
        }
    }

    private func addListenerToPKGame(gameUpdateListener: PKGameUpdateListener) {
        print("did add listener to game")
        self.gameDocumentRef.addSnapshotListener { [self] documentSnapshot, error in
            guard let snapShot = documentSnapshot else {
              print("Error fetching snapshots: \(error!)")
              return
            }

            guard let gameData: PKGameData = self.getModel(from: snapShot) else {
                print("Unable to convert data to PkGameData model")
                assert(false)
                return
            }

            self.pkGameUpdateListeners.forEach { updateListeners in
                updateListeners(gameUpdateListener, gameData)
            }
        }
    }

    private var forfeittedPlayerIds = Set<Identifier>()
    private func updateListenerOnForfeit(_ gameUpdateListener: PKGameUpdateListener, _ pkGameData: PKGameData) {
        let newForfeittedPlayers = pkGameData.forfeittedPlayers.subtracting(forfeittedPlayerIds)
        guard !newForfeittedPlayers.isEmpty else {
            print("No new forfeitted players")
            return
        }

        print("forfeittedPlayer ids: \(newForfeittedPlayers)")

        let forfeittedPlayers = self.pkGame.players.filter { newForfeittedPlayers.contains($0.id) }

        guard forfeittedPlayers.count == newForfeittedPlayers.count else {
//            assert(false)
            print("Received update on forfeit but player not in game.")
            return
        }

        for forfeittedPlayer in forfeittedPlayers {
            forfeittedPlayerIds.insert(forfeittedPlayer.id)
            gameUpdateListener.didForfeit(player: forfeittedPlayer)
        }
    }

    func didMove(move: PKGameMove) {
        _ = firstly {
            getMoveData(from: move)
        }.done { [self] moveData in
            do {
                _ = try self.moveCollectionRef.addDocument(from: moveData) { error in
                    if let error = error {
                        print("add game document error: \(error)")
                    } else {
                        print("successfully added document")
                    }
                }
            } catch {
                print("unable to add game move")
            }
        }
    }

    private func addListenerToMoves(gameUpdateListener: PKGameUpdateListener) {
        let moveListener = moveCollectionRef.addSnapshotListener { [self] querySnapshot, error in
            guard let snapShot = querySnapshot else {
              print("Error fetching snapshots: \(error!)")
              return
            }
            _ = snapShot.documentChanges.forEach { diff in
                if diff.type == .added, let moveData: PKGameMoveData = self.getModel(from: diff.document) {
                    _ = firstly {
                        self.getMove(from: moveData)
                    }.done { move in
                        gameUpdateListener.didMove(move)
                    }
                }
            }
        }

        firebaseMoveListeners.append(moveListener)
    }

    func removeListeners() {
        self.firebaseMoveListeners.forEach { $0.remove() }
    }

}

// MARK: Conversion between PKGameMove and PKGameMoveData
extension FirebasePKGameUpdater {
    private func getMove(from moveData: PKGameMoveData) -> Promise<PKGameMove> {
        firstly {
            profileManager.getProfile(id: moveData.player.id)
        }.map { playerProfile in
            PKGameMove(
                question: moveData.question,
                player: playerProfile,
                isCorrect: moveData.isCorrect,
                timeTaken: moveData.timeTaken,
                id: moveData.id)
        }
    }

    private func getMoveData(from move: PKGameMove) -> Promise<PKGameMoveData> {
        firstly {
            // TODO: Check if this is necessary (or if a simple conversion from profile to profileData is enough)
            profileManager.getOne(id: move.player.id)
        }.map {
            PKGameMoveData(question: move.question, player: $0, isCorrect: move.isCorrect, timeTaken: move.timeTaken)
        }
    }
}

// MARK: Processing documentData from Firebase
extension FirebasePKGameUpdater {
    private func processDocumentData(_ documentData: [String: Any]) -> [String: Any] {
        var newDocumentData = documentData
        newDocumentData.forEach { (key: String, value: Any) in
            switch value {
            case is DocumentReference:
                newDocumentData.removeValue(forKey: key)
            case let ts as Timestamp:
                let date = ts.dateValue()

                let jsonValue = Int((date.timeIntervalSince1970 * 1_000).rounded())
                newDocumentData[key] = jsonValue
            default:
                break
            }
        }
        return newDocumentData
    }

    private func getModel<T: Record>(from document: DocumentSnapshot) -> T? {
        guard var documentData = document.data() else {
            return nil
        }
        documentData["id"] = document.documentID

        let data = try? JSONSerialization.data(withJSONObject: processDocumentData(documentData))

        let model = try? JSONDecoder().decode(T.self, from: data ?? Data())

        return model
    }
}
