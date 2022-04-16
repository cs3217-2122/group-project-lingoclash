//
//  AppStoryboard.swift
//  LingoClash
//
// Referenced design from: https://medium.com/@gurdeep060289/clean-code-for-multiple-storyboards-c64eb679dbf6

import UIKit

enum AppStoryboard: String {
    case Main, Home, Profile, Lesson, Question
    var instance: UIStoryboard {
        UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}
