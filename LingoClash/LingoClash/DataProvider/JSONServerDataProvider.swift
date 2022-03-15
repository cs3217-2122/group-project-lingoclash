//
//  RestProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 14/3/22.
//

import Foundation
import PromiseKit

class JSONServerDataProvider: DataProvider {
    
    typealias HttpClient = (_ request: URLRequest) -> Promise<FetchResult>
    
    private let apiURL: String
    private var httpClient: HttpClient
    
    init(
        apiURL: String,
        httpClient: @escaping HttpClient = FetchUtilities.fetchData) {
            self.apiURL = apiURL
            self.httpClient = httpClient
        }
    
    func create(resource: String, params: CreateParams) -> Promise<CreateResult> {
        
        guard let url = URL(string: "\(apiURL)/\(resource)") else {
            return Promise.reject(
                reason: NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data
        
        return httpClient(request).map { fetchResult in
            CreateResult(data: fetchResult.data)
        }
    }
    
    func delete(resource: String, params: DeleteParams) -> Promise<DeleteResult> {
        guard let url = URL(string: "\(apiURL)/\(resource)/\(params.id)") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return httpClient(request).map { fetchResult in
            DeleteResult(data: fetchResult.data)
        }
    }
    
    func getList(resource: String, params: GetListParams) -> Promise<GetListResult> {
        let pagination = params.pagination
        let sort = params.sort
        let _query = [
            "_sort": sort.field,
            "_order": sort.order,
            "_start": (pagination.page - 1) * pagination.perPage,
            "_end": pagination.page * pagination.perPage
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
            
            return GetListResult(data: fetchResult.data, total: count)
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
    
    func update(resource: String, params: UpdateParams) -> Promise<UpdateResult> {
        guard let url = URL(string: "\(apiURL)/\(resource)/\(params.id)") else {
            return Promise.reject(reason: NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data
        
        return httpClient(request).map { fetchResult in
            UpdateResult(data: fetchResult.data)
        }
    }
    
}


