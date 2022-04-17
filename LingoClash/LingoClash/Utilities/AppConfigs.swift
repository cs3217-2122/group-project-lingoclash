//
//  Constants.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

struct AppConfigs {

    struct Debug {

        // Preloads the db with some sample data. Only works in development scheme.
        static let enablePreloadData = false
        static let enableLogin = false
        static let testAccounts: [LoginFields] = [
            LoginFields(email: "guy@gmail.com", password: "setMeUp?"),
            LoginFields(email: "e@e.com", password: "123456")
        ]
    }

    struct View {
        static let vocabCollectionCellIdentifier = "vocabCollectionCellIdentifier"
    }

    struct API {
        static let authProvider = FirebaseAuthProvider()
        static let dataProvider = FirebaseDataProvider()
        static let devService = "lingoclashdev.com"
        static let devServerBaseURL = "http://localhost:3000"
        static let perPage = 10
        static let field = "id"
        static let isDescending = true
        static let accessTokenKey = "access_token"
    }

}
