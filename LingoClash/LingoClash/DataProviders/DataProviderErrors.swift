//
//  DataProviderErrors.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidParams
    case invalidResponse
}

enum HTTPError: Error {
    case transportError(Error)
    case serverSideError(Int)
}
