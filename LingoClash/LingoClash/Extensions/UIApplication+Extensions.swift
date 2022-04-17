//
//  UIApplication+Extensions.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 16/4/22.
//
import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController?
                                    = UIApplication.shared.connectedScenes
                                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                    .first { $0.isKeyWindow }?.rootViewController)
    -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
