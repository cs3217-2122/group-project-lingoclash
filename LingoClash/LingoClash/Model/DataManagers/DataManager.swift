//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//
import Foundation
import PromiseKit

class DataManager<T: Codable> {

    private let dataProvider: DataProvider
    private let resource: String

    init(resource: String, dataProvider: DataProvider = FirebaseDataProvider()) {
        self.resource = resource
        self.dataProvider = dataProvider
    }

    func getList(
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]
    ) -> Promise<[T]> {

        let sort = SortPayload(field: field, order: order)
        let data = dataProvider.getList(resource: self.resource, params: GetListParams(
            sort: sort, filter: filter))

        return data.compactMap { result in
            result.data.compactMap {
                try? JSONDecoder().decode(T.self, from: $0)
            }
        }
    }

    func getOne(id: Identifier) -> Promise<T> {

        let data = dataProvider.getOne(resource: self.resource, params: GetOneParams(id: id))
        
        return data.compactMap { result in
            try? JSONDecoder().decode(T.self, from: result.data)
        }
    }

    func getMany(ids: [Identifier]) -> Promise<[T]> {

        let data = dataProvider.getMany(resource: self.resource, params: GetManyParams(ids: ids))

        return data.compactMap { result in
            result.data.compactMap {
                try? JSONDecoder().decode(T.self, from: $0)
            }
        }
    }

    func getManyReference(
        target: String,
        id: Identifier,
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]) -> Promise<[T]> {

            let sort = SortPayload(field: field, order: order)
            let data = dataProvider.getManyReference(
                resource: self.resource,
                params: GetManyReferenceParams(
                    target: target, id: id,
                    sort: sort, filter: filter))

            return data.compactMap { result in
                result.data.compactMap {
                    try? JSONDecoder().decode(T.self, from: $0)
                }
            }
        }

    func update(id: Identifier, from previousBook: T, to newBook: T) -> Promise<T> {

        let updatedData = dataProvider.update(resource: self.resource, params: UpdateParams(id: id, data: newBook, previousData: previousBook))

        return updatedData.compactMap { result in
            try? JSONDecoder().decode(T.self, from: result.data)
        }
    }

    /// id of the newBook does not matter
    func updateMany(ids: [Identifier], newBook: T) -> Promise<[Identifier]> {

        let updatedData = dataProvider.updateMany(resource: self.resource, params: UpdateManyParams(ids: ids, data: newBook))

        return updatedData.compactMap { result in
            result.data
        }
    }

    func create(newBook: T) -> Promise<T> {

        let createdData = dataProvider.create(resource: self.resource, params: CreateParams(data: newBook))

        return createdData.compactMap { result in
            try? JSONDecoder().decode(T.self, from: result.data)
        }
    }

    func delete(id: Identifier, book: T) -> Promise<T> {

        let deletedData = dataProvider.delete(resource: self.resource, params: DeleteParams(id: id, previousData: book))

        return deletedData.compactMap { result in
            try? JSONDecoder().decode(T.self, from: result.data)
        }
    }

    func deleteMany(ids: [Identifier]) -> Promise<[Identifier]> {

        let deletedData = dataProvider.deleteMany(resource: self.resource, params: DeleteManyParams(ids: ids))

        return deletedData.compactMap { result in
            result.data
        }
    }
}
