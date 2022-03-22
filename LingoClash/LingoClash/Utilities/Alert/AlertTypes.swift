//
//  AlertTypes.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

enum AlertType {
    case basic
    case confirm
}

struct AlertContent {
    let title: String
    let message: String
    let type: AlertType
}
