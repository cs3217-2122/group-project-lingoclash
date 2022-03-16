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
        super.init(apiURL: Constants.API.devServerBaseURL) { request in
            
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
