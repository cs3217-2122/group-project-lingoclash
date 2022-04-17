//
//  SnackbarViewModel.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//
typealias Handler = (() -> Void)

enum SnackbarType {
    case info
    case action(handler: Handler)
}

struct SnackbarViewModel {
    let type: SnackbarType
    let text: String
}
