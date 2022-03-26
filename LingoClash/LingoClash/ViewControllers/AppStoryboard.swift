//
//  AppStoryboard.swift
//  LingoClash
//
//  Created by Sherwin Poh on 26/3/22.
//

import UIKit

enum AppStoryboard: String {
    case Main, Home, Lesson, Question
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}
