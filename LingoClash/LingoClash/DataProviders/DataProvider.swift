//
//  DataProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

protocol DataProvider {
    
    func getList<T: Codable>(resource: String, params: GetListParams) -> Promise<GetListResult<T>>
    
    func getOne<T: Codable>(resource: String, params: GetOneParams) -> Promise<GetOneResult<T>>
    
    func getMany<T: Codable>(resource: String, params: GetManyParams) -> Promise<GetManyResult<T>>
    
    func getManyReference<T: Codable>(resource: String, params: GetManyReferenceParams) -> Promise<GetManyReferenceResult<T>>
    
    func update<T: Codable>(resource: String, params: UpdateParams<T>) -> Promise<UpdateResult>
    
    func updateMany<T: Codable>(resource: String, params: UpdateManyParams<T>) -> Promise<UpdateManyResult>
    
    func create<T: Codable>(resource: String, params: CreateParams<T>) -> Promise<CreateResult>
    
    func delete<T: Codable>(resource: String, params: DeleteParams<T>) ->
    Promise<DeleteResult>
    
    func deleteMany(resource: String, params: DeleteManyParams) -> Promise<DeleteManyResult>
    
}
