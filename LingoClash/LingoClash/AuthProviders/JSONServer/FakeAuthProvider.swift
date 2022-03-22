//
//  FakeAuthProvider.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation


class FakeAuthProvider: JSONServerAuthProvider {
    init() {
        super.init(apiURL: AppConfigs.API.devServerBaseURL)
    }
}
