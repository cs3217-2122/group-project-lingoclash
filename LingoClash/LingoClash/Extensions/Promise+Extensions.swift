//
//  Extensions.swift
//  LingoClash
//
//  Created by Kyle キラ on 15/3/22.
//

import Foundation
import PromiseKit

extension Promise {
    static func reject(reason: Error) -> Promise<T> {
        return Promise<T> { seal in
            seal.reject(reason)
        }
    }
    
    static func resolve<T>(value: T) -> Promise<T> {
        return Promise<T> { seal in
            seal.fulfill(value)
        }
    }
}
