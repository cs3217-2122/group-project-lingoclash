//
//  Constants.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

struct AppConfigs {

    struct StoryBoard {
        static let mainTabBarVC = "MainTabBarVC"
        static let splashVC = "SplashVC"
    }
    
    struct View {
        static let primaryColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    }
    
    struct API {
        static let devService = "lingoclashdev.com"
        static let devServerBaseURL = "http://localhost:3000"
        static let perPage = 10
        static let field = "id"
        static let order = "desc"
        static let accessTokenKey = "access_token"
    }
    
}
