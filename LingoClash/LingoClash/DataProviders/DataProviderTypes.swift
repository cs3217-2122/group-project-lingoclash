//
//  Types.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

import Foundation

typealias Identifier = String

protocol Record: Codable {
    var id: Identifier { get }
}

extension Record {
    // Local creation of Records to be pushed to DataProvider where id is useless
    static var placeholderId: Identifier { "PLACEHOLDER" }
}

struct CreateParams<T: Codable> {
    let data: T
}

struct CreateResult<T: Record> {
    let data: T
}

struct CreateManyParams<T: Record> {
    let data: [T]
}

struct CreateManyResult<T: Codable> {
    let data: [T]
}

struct DeleteParams<T: Codable> {
    let id: Identifier
    let previousData: T
}

struct DeleteResult<T: Codable> {
    let data: T
}

struct PaginationPayload {
    let page: Int
    let perPage: Int
}

struct SortPayload {
    let field: String
    let isDescending: Bool
}

struct GetListParams {
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetListResult<T: Codable> {
    let data: [T]
    let total: Int
}

struct GetOneParams {
    let id: Identifier
}

struct GetOneResult<T: Codable> {
    let data: T
}

struct GetManyParams {
    let ids: [Identifier]
}

struct GetManyResult<T: Codable> {
    let data: [T]
}

struct GetManyReferenceParams {
    let target: String
    let id: Identifier
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetManyReferenceResult<T: Codable> {
    let data: [T]
    let total: Int
}

struct UpdateParams<T: Codable> {
    let id: Identifier
    let data: T
    let previousData: T
}

struct UpdateResult<T: Codable> {
    let data: T
}

struct UpdateManyParams<T: Codable> {
    let ids: [Identifier]
    let data: T
}

struct UpdateManyResult {
    let data: [Identifier]
}

struct DeleteManyParams {
    let ids: [Identifier]
}

struct DeleteManyResult {
    let data: [Identifier]
}
