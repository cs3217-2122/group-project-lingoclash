//
//  Constants.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

struct Constants {
    
    struct ListConfig {
        static let perPage = 10
        static let field = "id"
        static let order = "desc"
    }
    
    struct API {
        static let devServerBaseURL = "http://localhost:3000"
    }
    
    struct StoryBoard {
        static let mainTabBarVC = "MainTabBarVC"
        static let splashVC = "SplashVC"
    }
    
    struct UI {
        static let primaryColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        static let vocabCollectionCellIdentifier = "vocabCollectionCellIdentifier"
    }
}
