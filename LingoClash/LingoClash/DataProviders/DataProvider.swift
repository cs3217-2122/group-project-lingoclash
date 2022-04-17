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

    func getManyReference<T: Codable>(
        resource: String,
        params: GetManyReferenceParams) -> Promise<GetManyReferenceResult<T>>

    func update<T: Codable>(resource: String, params: UpdateParams<T>) -> Promise<UpdateResult<T>>

    func updateMany<T: Codable>(resource: String, params: UpdateManyParams<T>) -> Promise<UpdateManyResult>

    func create<T: Record>(resource: String, params: CreateParams<T>) -> Promise<CreateResult<T>>

    func createMany<T: Record>(resource: String, params: CreateManyParams<T>) -> Promise<CreateManyResult<T>>

    func delete<T: Codable>(resource: String, params: DeleteParams<T>) -> Promise<DeleteResult<T>>

    func deleteMany(resource: String, params: DeleteManyParams) -> Promise<DeleteManyResult>

}
