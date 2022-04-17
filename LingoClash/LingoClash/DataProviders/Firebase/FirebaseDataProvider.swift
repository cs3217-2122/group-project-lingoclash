//
//  FirebaseDataProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseDataProvider: DataProvider {

    // TODO: think of better error names
    enum FirebaseDataProviderError: Error {
        case invalidParams
        case invalidQuerySnapshot
        case documentNotFound
        case serializationError
    }

    struct Configs {
        static let uidKey = "uid"
    }

    private let db = Firestore.firestore()

    private func getModel<S: Codable>(from document: DocumentSnapshot) -> S? {
        let model = document.decode(as: S.self)

        return model
    }

    func getList<T: Codable>(resource: String, params: GetListParams) -> Promise<GetListResult<T>> {

            Promise { seal in
                var filteredCollection: Query = db.collection(resource)
                for (key, value) in params.filter {
                    filteredCollection = filteredCollection.whereField(key, isEqualTo: value)
                }
                filteredCollection.getDocuments { querySnapshot, error in

                    if let error = error {
                        return seal.reject(error)
                    }

                    guard let querySnapshot = querySnapshot else {
                        return seal.reject(FirebaseDataProviderError.invalidQuerySnapshot)
                    }

                    let dataList = querySnapshot.documents.compactMap { document -> T? in
                        self.getModel(from: document)
                    }

                    return seal.fulfill(GetListResult(data: dataList, total: querySnapshot.count))
                }
            }
    }

    func getOne<T: Codable>(resource: String, params: GetOneParams) -> Promise<GetOneResult<T>> {

        Promise { seal in
            let docRef = db.collection(resource).document(params.id)

            docRef.getDocument { document, error in
                if let error = error {
                    return seal.reject(error)
                }

                guard let document = document, document.exists else {
                    return seal.reject(FirebaseDataProviderError.documentNotFound)
                }

                guard let data: T = self.getModel(from: document) else {
                    return seal.reject(FirebaseDataProviderError.serializationError)
                }

                return seal.fulfill(GetOneResult(data: data))
            }
        }
    }

    func getMany<T: Codable>(resource: String, params: GetManyParams) -> Promise<GetManyResult<T>> {

        Promise { seal in
            let collection = db.collection(resource)

            collection.whereField(FieldPath.documentID(), in: params.ids).getDocuments { querySnapshot, error in

                if let error = error {
                    return seal.reject(error)
                }

                guard let querySnapshot = querySnapshot else {
                    return seal.reject(FirebaseDataProviderError.invalidQuerySnapshot)
                }

                let dataList = querySnapshot.documents.compactMap { document -> T? in

                    self.getModel(from: document)
                }

                return seal.fulfill(GetManyResult(data: dataList))
            }
        }
    }

    func getManyReference<T: Codable>(resource: String, params: GetManyReferenceParams)
        -> Promise<GetManyReferenceResult<T>> {

        Promise { seal in
            var filteredCollection = db.collection(resource).whereField(params.target, isEqualTo: params.id)

            for (key, value) in params.filter {
                filteredCollection = filteredCollection.whereField(key, isEqualTo: value)
            }

            filteredCollection.getDocuments { querySnapshot, error in

                if let error = error {
                    return seal.reject(error)
                }

                guard let querySnapshot = querySnapshot else {
                    return seal.reject(FirebaseDataProviderError.invalidQuerySnapshot)
                }

                let dataList = querySnapshot.documents.compactMap { document -> T? in
                    self.getModel(from: document)
                }

                return seal.fulfill(GetManyReferenceResult(data: dataList, total: querySnapshot.count))
            }
        }
    }

    func update<T: Codable>(resource: String, params: UpdateParams<T>) -> Promise<UpdateResult<T>> {

        Promise { seal in
            do {
                try db.collection(resource).document(params.id).setData(from: params.data, merge: true) { error in

                    if let error = error {
                        return seal.reject(error)
                    }

                    return seal.fulfill(UpdateResult(data: params.data))
                }
            } catch {
                seal.reject(error)
            }
        }
    }

    // See: https://firebase.google.com/docs/firestore/manage-data/transactions
    func updateMany<T: Codable>(resource: String, params: UpdateManyParams<T>) -> Promise<UpdateManyResult> {

        let batch = db.batch()

        for id in params.ids {
            let docRef = db.collection(resource).document(id)
            do {
                try batch.setData(from: params.data, forDocument: docRef, merge: true)
            } catch {
                return Promise.reject(reason: error)
            }
        }

        return Promise { seal in
            batch.commit { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(UpdateManyResult(data: params.ids))
            }
        }
    }

    /// id matters
    func createMany<T: Record>(resource: String, params: CreateManyParams<T>) -> Promise<CreateManyResult<T>> {

        let batch = db.batch()

        for data in params.data {
            let docRef = db.collection(resource).document(data.id)
            do {
                try batch.setData(from: data, forDocument: docRef)
            } catch {
                return Promise.reject(reason: error)
            }
        }

        return Promise { seal in
            batch.commit { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(CreateManyResult(data: params.data))
            }
        }
    }

    func create<T: Codable>(resource: String, params: CreateParams<T>) -> Promise<CreateResult<T>> {

        Promise { seal in
            do {
                var ref: DocumentReference?

                ref = try db.collection(resource).addDocument(from: params.data) { error in
                    if let error = error {
                        return seal.reject(error)
                    }
                }

                guard let ref = ref else {
                    return seal.reject(FirebaseDataProviderError.documentNotFound)
                }

                ref.getDocument { document, error in
                    if let error = error {
                        return seal.reject(error)
                    }

                    guard let document = document, document.exists else {
                        return seal.reject(FirebaseDataProviderError.documentNotFound)
                    }

                    guard let data: T = self.getModel(from: document) else {
                        return seal.reject(FirebaseDataProviderError.serializationError)
                    }

                    return seal.fulfill(CreateResult(data: data))
                }

            } catch {
                seal.reject(error)
            }
        }
    }

    func delete<T: Codable>(resource: String, params: DeleteParams<T>) -> Promise<DeleteResult<T>> {
        Promise { seal in
            db.collection(resource).document(params.id).delete { error in

                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(DeleteResult(data: params.previousData))
            }
        }
    }

    func deleteMany(resource: String, params: DeleteManyParams) -> Promise<DeleteManyResult> {
        let batch = db.batch()

        for id in params.ids {
            let docRef = db.collection(resource).document(id)
            batch.deleteDocument(docRef)
        }

        return Promise { seal in
            batch.commit { error in
                if let error = error {
                    return seal.reject(error)
                }

                return seal.fulfill(DeleteManyResult(data: params.ids))
            }
        }
    }

    // converts from firebase types to swift types
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
}
