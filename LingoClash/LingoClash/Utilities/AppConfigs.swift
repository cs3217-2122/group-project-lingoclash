//
//  Constants.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

struct AppConfigs {
    
    struct General {
        static let enablePreloadData = false
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
        static let order = "desc"
        static let accessTokenKey = "access_token"
    }
    
}
