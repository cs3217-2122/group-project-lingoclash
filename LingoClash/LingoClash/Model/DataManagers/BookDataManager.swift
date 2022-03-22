//
//  BookDataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

class BookDataManager {
    
    private let dataProvider: DataProvider
    private let resource = "books"
    
    init(dataProvider: DataProvider = FirebaseDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    func getList(
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]
    ) -> Promise<[Book]> {
        
        let sort = SortPayload(field: field, order: order)
        let data = dataProvider.getList(resource: self.resource, params: GetListParams(
            sort: sort, filter: filter))
        
        return data.compactMap { result in
            result.data.compactMap {
                try? JSONDecoder().decode(Book.self, from: $0)
            }
        }
        
    }
    
    func getOne(id: Identifier) -> Promise<Book> {
        
        let data = dataProvider.getOne(resource: self.resource, params: GetOneParams(id: id))
        
        return data.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    func getMany(ids: [Identifier]) -> Promise<[Book]> {
        
        let data = dataProvider.getMany(resource: self.resource, params: GetManyParams(ids: ids))
        
        return data.compactMap { result in
            result.data.compactMap {
                try? JSONDecoder().decode(Book.self, from: $0)
            }
        }
    }
    
    func getManyReference(
        target: String,
        id: Identifier,
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]) -> Promise<[Book]> {
            
            let sort = SortPayload(field: field, order: order)
            let data = dataProvider.getManyReference(
                resource: self.resource,
                params: GetManyReferenceParams(
                    target: target, id: id,
                    sort: sort, filter: filter))
            
            return data.compactMap { result in
                result.data.compactMap {
                    try? JSONDecoder().decode(Book.self, from: $0)
                }
            }
        }
    
    func update(id: Identifier, from previousBook: Book, to newBook: Book) -> Promise<Book> {
        
        let updatedData = dataProvider.update(resource: self.resource, params: UpdateParams(id: id, data: newBook, previousData: previousBook))
        
        return updatedData.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    /// id of the newBook does not matter
    func updateMany(ids: [Identifier], newBook: Book) -> Promise<[Identifier]> {
        
        let updatedData = dataProvider.updateMany(resource: self.resource, params: UpdateManyParams(ids: ids, data: newBook))
        
        return updatedData.compactMap { result in
            result.data
        }
    }
    
    func create(newBook: Book) -> Promise<Book> {
        
        let createdData = dataProvider.create(resource: self.resource, params: CreateParams(data: newBook))
        
        return createdData.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    func delete(id: Identifier, book: Book) -> Promise<Book> {
        
        let deletedData = dataProvider.delete(resource: self.resource, params: DeleteParams(id: id, previousData: book))
        
        return deletedData.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    func deleteMany(ids: [Identifier]) -> Promise<[Identifier]> {
        
        let deletedData = dataProvider.deleteMany(resource: self.resource, params: DeleteManyParams(ids: ids))
        
        return deletedData.compactMap { result in
            result.data
        }
    }
}
