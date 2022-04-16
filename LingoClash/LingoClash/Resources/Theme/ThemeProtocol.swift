//
//  ThemeProtocol.swift
//  LingoClash
//
//  Created by Kyle キラ on 12/4/22.
//

import UIKit

protocol ThemeProtocol {
    var mainFontName: String { get }
    var accent: UIColor { get }
    var background: UIColor { get }
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var tertiary: UIColor { get }
    var error: UIColor { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var tertiaryText: UIColor { get }
    var errorText: UIColor { get }
    var errorContainer: UIColor { get }

    var tint: UIColor { get }
    var green: UIColor { get }
    var red: UIColor { get }
}
