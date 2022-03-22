//
//  RestProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

/**
 * Maps queries to a json-server powered REST API
 *
 * @see https://github.com/typicode/json-server
 *
 * @example
 *
 * getList            => GET http://my.api.url/posts?_sort=title&_order=ASC&_start=0&_end=24
 * getOne           => GET http://my.api.url/posts/123
 * getManyReference => GET http://my.api.url/posts?author_id=345
 * getMany         => GET http://my.api.url/posts?id=123&id=456&id=789
 * create             => POST http://my.api.url/posts/123
 * update            => PUT http://my.api.url/posts/123
 * updateMany   => PUT http://my.api.url/posts/123, PUT http://my.api.url/posts/456, PUT http://my.api.url/posts/789
 * delete             => DELETE http://my.api.url/posts/123
 *
 */

class JSONServerDataProvider: DataProvider {
    
    struct Configs {
        static let sortKey = "_sort"
        static let orderKey = "_order"
        static let startKey = "_start"
        static let endKey = "_end"
    }
    
    typealias HttpClient = (_ request: URLRequest) -> Promise<FetchResult>
    
    private let apiURL: String
    private var httpClient: HttpClient
    
    init(
        apiURL: String,
        httpClient: @escaping HttpClient = FetchUtilities.fetchData) {
            self.apiURL = apiURL
            self.httpClient = httpClient
        }
    
    func getList(resource: String, params: GetListParams) -> Promise<GetListResult> {
        //        let pagination = params.pagination
        let sort = params.sort
        let _query = [
            Configs.sortKey: sort.field,
            Configs.orderKey: sort.order,
            //            Configs.startKey: (pagination.page - 1) * pagination.perPage,
            //            Configs.endKey: pagination.page * pagination.perPage
        ] as [String : Any]
        let query = _query.merging(params.filter) { (current, _) in current }
        
        guard let url = URL(string: "\(apiURL)/\(resource)?\(FetchUtilities.stringify(query: query))") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        let request = URLRequest(url: url)
        
        return httpClient(request).compactMap { fetchResult in
            
            let response = fetchResult.response as? HTTPURLResponse
            guard let count = Int(response?.allHeaderFields["X-Total-Count"] as? String ?? "") else {
                return nil
            }
            
            guard let items = try? JSONSerialization.jsonObject(with: fetchResult.data, options: []) as? [Any] else {
                return nil
            }
            let dataList = items.compactMap { item in
                try? JSONSerialization.data(withJSONObject: item, options: [])
            }
            
            return GetListResult(data: dataList, total: count)
        }
    }
    
    func getOne(resource: String, params: GetOneParams) -> Promise<GetOneResult> {
        guard let url = URL(string: "\(apiURL)/\(resource)/\(params.id)") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        let request = URLRequest(url: url)
        
        return httpClient(request).map { fetchResult in
            GetOneResult(data: fetchResult.data)
        }
    }
    
    func getMany(resource: String, params: GetManyParams) -> Promise<GetManyResult> {
        let query = [
            "id": params.ids,
        ]
        guard let url = URL(string: "\(apiURL)/\(resource)?\(FetchUtilities.stringify(query: query))") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        let request = URLRequest(url: url)
        
        return httpClient(request).compactMap { fetchResult in
            
            guard let items = try? JSONSerialization.jsonObject(with: fetchResult.data, options: []) as? [Any] else {
                return nil
            }
            let dataList = items.compactMap { item in
                try? JSONSerialization.data(withJSONObject: item, options: [])
            }
            
            return GetManyResult(data: dataList)
        }
    }
    
    func getManyReference(resource: String, params: GetManyReferenceParams) -> Promise<GetManyReferenceResult> {
        //        let pagination = params.pagination
        let sort = params.sort
        let _query = [
            params.target: params.id,
            Configs.sortKey: sort.field,
            Configs.orderKey: sort.order,
            //            Configs.startKey: (pagination.page - 1) * pagination.perPage,
            //            Configs.endKey: pagination.page * pagination.perPage
        ] as [String : Any]
        let query = _query.merging(params.filter) { (current, _) in current }
        
        guard let url = URL(string: "\(apiURL)/\(resource)?\(FetchUtilities.stringify(query: query))") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        let request = URLRequest(url: url)
        
        return httpClient(request).compactMap { fetchResult in
            
            let response = fetchResult.response as? HTTPURLResponse
            guard let count = Int(response?.allHeaderFields["X-Total-Count"] as? String ?? "") else {
                return nil
            }
            
            guard let items = try? JSONSerialization.jsonObject(with: fetchResult.data, options: []) as? [Any] else {
                return nil
            }
            let dataList = items.compactMap { item in
                try? JSONSerialization.data(withJSONObject: item, options: [])
            }
            
            return GetManyReferenceResult(data: dataList, total: count)
        }
        
    }
    
    func update<T: Codable>(resource: String, params: UpdateParams<T>) -> Promise<UpdateResult> {
        guard let url = URL(string: "\(apiURL)/\(resource)/\(params.id)") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        
        guard let data = try? JSONEncoder().encode(params.data) else {
            return Promise.reject(reason: NetworkError.invalidParams)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return httpClient(request).map { fetchResult in
            UpdateResult(data: fetchResult.data)
        }
    }
    
    // json-server doesn't handle filters on UPDATE route, so we fallback to calling UPDATE n times instead
    func updateMany<T: Codable>(resource: String, params: UpdateManyParams<T>) -> Promise<UpdateManyResult> {
        
        firstly { () -> Promise<[FetchResult]> in
            let promises = params.ids.map { id -> Promise<FetchResult> in
                guard let url = URL(string: "\(apiURL)/\(resource)/\(id)") else {
                    return Promise.reject(reason: NetworkError.invalidURL)
                }
                
                guard let data = try? JSONEncoder().encode(params.data) else {
                    return Promise.reject(reason: NetworkError.invalidParams)
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = data
                
                return httpClient(request)
            }
            
            return when(fulfilled: promises)
        }.map { results in
            UpdateManyResult(data: results.compactMap {
                let record = try? JSONDecoder().decode(
                    Record.self, from: $0.data)
                
                return record?.id
            })
        }
        
    }
    
    func create<T: Codable>(resource: String, params: CreateParams<T>) -> Promise<CreateResult> {
        
        guard let url = URL(string: "\(apiURL)/\(resource)") else {
            return Promise.reject(
                reason: NetworkError.invalidURL)
        }
        
        guard let data = try? JSONEncoder().encode(params.data) else {
            return Promise.reject(reason: NetworkError.invalidParams)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return httpClient(request).map { fetchResult in
            CreateResult(data: fetchResult.data)
        }
    }
    
    func delete<T: Codable>(resource: String, params: DeleteParams<T>) -> Promise<DeleteResult> {
        guard let url = URL(string: "\(apiURL)/\(resource)/\(params.id)") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return httpClient(request).map { fetchResult in
            DeleteResult(data: fetchResult.data)
        }
    }
    
    // json-server doesn't handle filters on DELETE route, so we fallback to calling DELETE n times instead
    func deleteMany(resource: String, params: DeleteManyParams) -> Promise<DeleteManyResult> {
        
        firstly { () -> Promise<[FetchResult]> in
            let promises = params.ids.map { id -> Promise<FetchResult> in
                guard let url = URL(string: "\(apiURL)/\(resource)/\(id)") else {
                    return Promise.reject(reason: NetworkError.invalidURL)
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                
                return httpClient(request)
            }
            
            return when(fulfilled: promises)
        }.map { results in
            DeleteManyResult(data: results.compactMap {
                let record = try? JSONDecoder().decode(
                    Record.self, from: $0.data)
                
                return record?.id
            })
        }
        
    }
    
}


