//
//  FakeDataProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

import Foundation
import PromiseKit


class FakeDataProvider: JSONServerDataProvider {
    
    init() {
        super.init(apiURL: AppConfigs.API.devServerBaseURL) { request in
            
            var request = request
            
            if let accessTokenData = KeychainManager.get(service: AppConfigs.API.devService, account: AppConfigs.API.accessTokenKey) {
                let accessToken = String(decoding: accessTokenData, as: UTF8.self)
                
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            
            return Promise { seal in
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        seal.reject(error)
                    } else {
                        seal.fulfill(
                            FetchResult(
                                data: data ?? Data(),
                                response: response
                            )
                        )
                    }
                }
                task.resume()
            }
        }
    }
    
}
