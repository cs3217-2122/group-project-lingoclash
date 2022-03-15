//
//  DataProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

protocol DataProvider {
    
    func getList(resource: String, params: GetListParams) -> Promise<GetListResult>
    
    func getOne(resource: String, params: GetOneParams) -> Promise<GetOneResult>
    
    func getMany(resource: String, params: GetManyParams) -> Promise<GetManyResult>
    
    func getManyReference(resource: String, params: GetManyReferenceParams) -> Promise<GetManyReferenceResult>
    
    func update(resource: String, params: UpdateParams) -> Promise<UpdateResult>
    
    func updateMany(resource: String, params: UpdateManyParams) -> Promise<UpdateManyResult>
    
    func create(resource: String, params: CreateParams) -> Promise<CreateResult>
    
    func delete(resource: String, params: DeleteParams) ->
    Promise<DeleteResult>
    
    func deleteMany(resource: String, params: DeleteManyParams) -> Promise<DeleteManyResult>
    
}
