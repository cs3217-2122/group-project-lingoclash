//
//  SnackbarUtilities.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 16/4/22.
//
import UIKit

class SnackbarUtilities {
    static func showSnackbar(type: SnackbarType, text: String) {
        if let topVC = UIApplication.getTopViewController() {
            let viewModel = SnackbarViewModel(type: .info, text: text)
            topVC.showSnackbar(snackbar: viewModel)
        }
    }
}
