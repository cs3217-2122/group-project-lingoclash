//
//  UiViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 26/3/22.
//

import UIKit

extension UIViewController {
    class var storyboardID: String {
        "\(self)"
    }

    static func instantiateFromAppStoryboard(_ appStoryboard: AppStoryboard) -> Self {
        appStoryboard.viewController(
            viewControllerClass: self)
    }
}
