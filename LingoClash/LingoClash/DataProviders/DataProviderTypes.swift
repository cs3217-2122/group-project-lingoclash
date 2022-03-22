//
//  Types.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

import Foundation

typealias Identifier = String

struct Record: Codable {
    let id: Identifier
}

struct CreateParams<T: Codable> {
    let data: T
}

struct CreateResult {
    let data: Data
}

struct DeleteParams<T: Codable> {
    let id: Identifier
    let previousData: T
}

struct DeleteResult {
    let data: Data
}

struct PaginationPayload {
    let page: Int
    let perPage: Int
}

struct SortPayload {
    let field: String
    let order: String
}

struct GetListParams {
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetListResult {
    let data: [Data]
    let total: Int
}

struct GetOneParams {
    let id: Identifier
}

struct GetOneResult {
    let data: Data
}

struct GetManyParams {
    let ids: [Identifier]
}

struct GetManyResult {
    let data: [Data]
}

struct GetManyReferenceParams {
    let target: String
    let id: Identifier
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetManyReferenceResult {
    let data: [Data]
    let total: Int
}

struct UpdateParams<T: Codable> {
    let id: Identifier
    let data: T
    let previousData: T
}

struct UpdateResult {
    let data: Data
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
