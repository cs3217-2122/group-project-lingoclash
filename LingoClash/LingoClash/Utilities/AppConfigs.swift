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
        static let primaryColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        static let vocabCollectionCellIdentifier = "vocabCollectionCellIdentifier"
        static let blue = #colorLiteral(red: 0.3065024073, green: 0.6942780921, blue: 1, alpha: 1)
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
