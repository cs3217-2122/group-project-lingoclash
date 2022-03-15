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
    
    init(dataProvider: DataProvider = FakeDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    func getList(
        page: Int,
        perPage: Int = Constants.ListConfig.perPage,
        field: String = Constants.ListConfig.field,
        order: String = Constants.ListConfig.order,
        filter: [String: Any] = [:]
    ) -> Promise<[Book]> {
        
        let pagination = PaginationPayload(page: page, perPage: perPage)
        let sort = SortPayload(field: field, order: order)
        let data = dataProvider.getList(resource: self.resource, params: GetListParams(pagination: pagination, sort: sort, filter: filter))
        
        return data.compactMap { result in
            try? JSONDecoder().decode(
                [Book].self, from: result.data)
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
            try? JSONDecoder().decode(
                [Book].self, from: result.data)
        }
    }
    
    func getManyReference(
        target: String,
        id: Identifier,
        page: Int,
        perPage: Int = Constants.ListConfig.perPage,
        field: String = Constants.ListConfig.field,
        order: String = Constants.ListConfig.order,
        filter: [String: Any] = [:]) -> Promise<[Book]> {
            
            let pagination = PaginationPayload(page: page, perPage: perPage)
            let sort = SortPayload(field: field, order: order)
            let data = dataProvider.getManyReference(
                resource: self.resource,
                params: GetManyReferenceParams(
                    target: target, id: id, pagination: pagination, sort: sort, filter: filter))
            
            return data.compactMap { result in
                try? JSONDecoder().decode(
                    [Book].self, from: result.data)
            }
        }
    
    func update(id: Identifier, from previousBook: Book, to newBook: Book) -> Promise<Book> {
        
        guard let previousData = try? JSONEncoder().encode(previousBook) else {
            return Promise.reject(reason: DatabaseError.invalidFormat)
        }
        
        guard let newData = try? JSONEncoder().encode(newBook) else {
            return Promise.reject(reason: DatabaseError.invalidFormat)
        }
        
        let updatedData = dataProvider.update(resource: self.resource, params: UpdateParams(id: id, data: newData, previousData: previousData))
        
        return updatedData.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    /// id of the newBook does not matter
    func updateMany(ids: [Identifier], newBook: Book) -> Promise<[Identifier]> {
        
        guard let data = try? JSONEncoder().encode(newBook) else {
            return Promise.reject(reason: DatabaseError.invalidFormat)
        }
        
        let updatedData = dataProvider.updateMany(resource: self.resource, params: UpdateManyParams(ids: ids, data: data))
        
        return updatedData.compactMap { result in
            result.data
        }
    }
    
    func create(newBook: Book) -> Promise<Book> {
        
        guard let data = try? JSONEncoder().encode(newBook) else {
            return Promise.reject(reason: DatabaseError.invalidFormat)
        }
        let createdData = dataProvider.create(resource: self.resource, params: CreateParams(data: data))
        
        return createdData.compactMap { result in
            try? JSONDecoder().decode(Book.self, from: result.data)
        }
    }
    
    func delete(id: Identifier, book: Book) -> Promise<Book> {
        
        guard let previousData = try? JSONEncoder().encode(book) else {
            return Promise.reject(reason: DatabaseError.invalidFormat)
        }
        
        let deletedData = dataProvider.delete(resource: self.resource, params: DeleteParams(id: id, previousData: previousData))
        
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
