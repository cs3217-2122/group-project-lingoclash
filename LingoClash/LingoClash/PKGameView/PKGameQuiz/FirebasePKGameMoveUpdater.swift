//
//  FirebasePKGameMoveUpdater.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//
import PromiseKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebasePKGameMoveUpdater: PKGameMoveUpdateDelegate {
    // TODO: abstract this away into a general synchroniser class
    var moveCollectionRef: CollectionReference
    private let db = Firestore.firestore()
    var firebaseMoveListener: ListenerRegistration?
    let profileManager = ProfileManager()
    init(game: PKGame) {
        self.moveCollectionRef = db.collection("PKGame").document(game.id).collection("moves")
    }
    
    var moveListener: PKGameMoveListener? {
        didSet {
            addListenerToMoves()
        }
    }
    
    func didMove(move: PKGameMove) {
        firstly {
            getMoveData(from: move)
        }.done { [self] moveData in
            do {
                try self.moveCollectionRef.addDocument(from: moveData) { error in
                    if let error = error {
                        print("add game document error")
                    } else {
                        print("successfully added document")
                    }
                }
            } catch {
                print("unable to add game move")
            }
        }
    }
    
    private func addListenerToMoves() {
        firebaseMoveListener = moveCollectionRef.addSnapshotListener { [self] querySnapshot, error in
            guard let snapShot = querySnapshot else {
              print("Error fetching snapshots: \(error!)")
              return
            }
            snapShot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let moveData = self.getModel(from: diff.document) {
                        firstly {
                            self.getMove(from: moveData)
                        }.done { move in
                            print("added move: \(move)")
                            self.updateMoveListener(with: move)
                        }
                    }

                }
                if (diff.type == .modified) {
                    print("Modified move: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed move: \(diff.document.data())")
                }
            }
        }
    }
    
    func removeListener() {
        self.firebaseMoveListener?.remove()
    }
    
    private func updateMoveListener(with move: PKGameMove) {
        self.moveListener?.didMove(move)
    }
    

}

// MARK: Conversion between PKGameMove and PKGameMoveData
extension FirebasePKGameMoveUpdater {
    private func getMove(from moveData: PKGameMoveData) -> Promise<PKGameMove> {
        return firstly {
            profileManager.getProfile(id: moveData.player.id)
        }.map { playerProfile in
            return PKGameMove(question: moveData.question, player: playerProfile, isCorrect: moveData.isCorrect, timeTaken: moveData.timeTaken, id: moveData.id)
        }
    }
    
    private func getMoveData(from move: PKGameMove) -> Promise<PKGameMoveData> {
        return firstly {
            // TODO: Check if this is necessary (or if a simple conversion from profile to profileData is enough)
            profileManager.getOne(id: move.player.id)
        }.map {
            PKGameMoveData(question: move.question, player: $0, isCorrect: move.isCorrect, timeTaken: move.timeTaken)
        }
    }
}

// MARK: Processing documentData from Firebase
extension FirebasePKGameMoveUpdater {
    private func processDocumentData(_ documentData: [String: Any]) -> [String: Any] {
        var newDocumentData = documentData
        newDocumentData.forEach { (key: String, value: Any) in
            switch value{
            case is DocumentReference:
                newDocumentData.removeValue(forKey: key)
                break
            case let ts as Timestamp:
                let date = ts.dateValue()
                
                let jsonValue = Int((date.timeIntervalSince1970 * 1000).rounded())
                newDocumentData[key] = jsonValue
                break
            default:
                break
            }
        }
        return newDocumentData
    }
    
    private func getModel(from document: DocumentSnapshot) -> PKGameMoveData? {
        guard var documentData = document.data() else {
            return nil
        }
        documentData["id"] = document.documentID
        
        let data = try? JSONSerialization.data(withJSONObject: processDocumentData(documentData))
        
        let model = try? JSONDecoder().decode(PKGameMoveData.self, from: data ?? Data())
        
        return model
    }
}
