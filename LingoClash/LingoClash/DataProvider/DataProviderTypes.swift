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

struct CreateParams {
    let data: Data
}

struct CreateResult {
    let data: Data
}

struct DeleteParams {
    let id: Identifier
    let previousData: Data
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
    let pagination: PaginationPayload
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetListResult {
    let data: Data
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
    let data: Data
}

struct GetManyReferenceParams {
    let target: String
    let id: Identifier
    let pagination: PaginationPayload
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetManyReferenceResult {
    let data: Data
    let total: Int
}

struct UpdateParams {
    let id: Identifier
    let data: Data
    let previousData: Data
}

struct UpdateResult {
    let data: Data
}

struct UpdateManyParams {
    let ids: [Identifier]
    let data: Data
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
