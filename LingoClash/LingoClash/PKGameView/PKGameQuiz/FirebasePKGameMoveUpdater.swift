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
    var moveCollectionRef: CollectionReference
    private let db = Firestore.firestore()
    var firebaseMoveListener: ListenerRegistration?
    init(game: PKGame) {
        self.moveCollectionRef = db.collection("PKGame").document(game.id).collection("moves")
    }
    
    var moveListener: PKGameMoveListener? {
        didSet {
            addListenerToMoves()
        }
    }
    
    func addListenerToMoves() {
        firebaseMoveListener = moveCollectionRef.addSnapshotListener { querySnapshot, error in
            guard let snapShot = querySnapshot else {
              print("Error fetching snapshots: \(error!)")
              return
            }
            snapShot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let move = self.getModel(from: diff.document) {
                        print("added move: \(move)")
                        self.moveListener?.didMove(move)
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
    
    private func getModel(from document: DocumentSnapshot) -> PKGameMove? {
        guard var documentData = document.data() else {
            return nil
        }
        documentData["id"] = document.documentID
        
        let data = try? JSONSerialization.data(withJSONObject: processDocumentData(documentData))
        
        let model = try? JSONDecoder().decode(PKGameMove.self, from: data ?? Data())
        
        return model
    }
    
    func removeListener() {
        self.firebaseMoveListener?.remove()
    }
    
    func didMove(move: PKGameMove) {
        do {
            try moveCollectionRef.addDocument(from: move) { error in
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
