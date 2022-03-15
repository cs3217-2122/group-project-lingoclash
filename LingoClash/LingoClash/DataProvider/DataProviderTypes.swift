//
//  Types.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

import Foundation

typealias Identifier = String

typealias Record = Data

struct CreateParams {
    let data: Record
}

struct CreateResult {
    let data: Record
}

struct DeleteParams {
    let id: Identifier
    let previousData: Record
}

struct DeleteResult {
    let data: Record?
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
    let data: Record
    let total: Int
}

struct GetOneParams {
    let id: Identifier
}

struct GetOneResult {
    let data: Record
}

struct GetManyParams {
    let ids: [Identifier]
}

struct GetManyResult {
    let data: Record
}

struct GetManyReferenceParams {
    let target: String
    let id: Identifier
    let pagination: PaginationPayload
    let sort: SortPayload
    let filter: [String: Any]
}

struct GetManyReferenceResult {
    let data: Record
    let total: Int
}

struct UpdateParams {
    let id: Identifier
    let data: Record
    let previousData: Record
}

struct UpdateResult {
    let data: Record
}
