//
//  DataManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//
import Foundation
import PromiseKit

class DataManager<T: Record> {
    
    private let dataProvider: DataProvider
    private let resource: String
    
    init(resource: String, dataProvider: DataProvider = AppConfigs.API.dataProvider) {
        self.resource = resource
        self.dataProvider = dataProvider
    }
    
    func getList(
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]
    ) -> Promise<[T]> {
        
        let sort = SortPayload(field: field, order: order)
        let result: Promise<GetListResult<T>> = dataProvider.getList(resource: self.resource, params: GetListParams(
            sort: sort, filter: filter))
        
        return result.map { result in
            result.data
        }
    }
    
    func getOne(id: Identifier) -> Promise<T> {
        
        let result: Promise<GetOneResult<T>> = dataProvider.getOne(resource: self.resource, params: GetOneParams(id: id))
        
        return result.map { result in
            result.data
        }
    }
    
    func getMany(ids: [Identifier]) -> Promise<[T]> {

        let result: Promise<GetManyResult<T>> = dataProvider.getMany(resource: self.resource, params: GetManyParams(ids: ids))
        
        return result.map { result in
            result.data
        }
    }
    
    func getManyReference(
        target: String,
        id: Identifier,
        field: String = AppConfigs.API.field,
        order: String = AppConfigs.API.order,
        filter: [String: Any] = [:]) -> Promise<[T]> {
            
            let sort = SortPayload(field: field, order: order)
            let result: Promise<GetManyReferenceResult<T>> = dataProvider.getManyReference(
                resource: self.resource,
                params: GetManyReferenceParams(
                    target: target, id: id,
                    sort: sort, filter: filter))
            
            return result.map { result in
                result.data
            }
            
        }
    
    func update(id: Identifier, from previousRecord: T, to newRecord: T) -> Promise<T> {
        
        let updatedData = dataProvider.update(resource: self.resource, params: UpdateParams(id: id, data: newRecord, previousData: previousRecord))
        
        return updatedData.compactMap { result in
            result.data
        }
    }
    
    /// id of the newRecord does not matter
    func updateMany(ids: [Identifier], newRecord: T) -> Promise<[Identifier]> {
        
        let updatedData = dataProvider.updateMany(resource: self.resource, params: UpdateManyParams(ids: ids, data: newRecord))
        
        return updatedData.compactMap { result in
            result.data
        }
    }
    
    func create(newRecord: T) -> Promise<T> {
        
        let createdData = dataProvider.create(resource: self.resource, params: CreateParams(data: newRecord))
        
        return createdData.compactMap { result in
            result.data
        }
    }
    
    func createMany(newRecords: [T]) -> Promise<[T]> {
        
        let createdData = dataProvider.createMany(resource: self.resource, params: CreateManyParams(data: newRecords))
        
        return createdData.compactMap { result in
            result.data
        }
    }
    
    func delete(id: Identifier, book: T) -> Promise<T> {
        
        let deletedData = dataProvider.delete(resource: self.resource, params: DeleteParams(id: id, previousData: book))
        
        return deletedData.compactMap { result in
            result.data
        }
    }
    
    func deleteMany(ids: [Identifier]) -> Promise<[Identifier]> {
        
        let deletedData = dataProvider.deleteMany(resource: self.resource, params: DeleteManyParams(ids: ids))
        
        return deletedData.compactMap { result in
            result.data
        }
    }
}
