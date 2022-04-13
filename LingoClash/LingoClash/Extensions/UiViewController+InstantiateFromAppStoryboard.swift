//
//  UiViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 26/3/22.
//

import UIKit

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(_ appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
