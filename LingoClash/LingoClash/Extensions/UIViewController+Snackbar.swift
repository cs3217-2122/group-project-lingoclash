//
//  UIViewController+Snackbar.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 16/4/22.
//
import UIKit

extension UIViewController {

    func showSnackbar(snackbar: SnackbarViewModel) {
        let snackbarWidth = view.frame.size.width / 1.5
        let frame = CGRect(x: 0, y: 0, width: snackbarWidth, height: 60)
        let snackbarView = SnackbarView(viewModel: snackbar, frame: frame)

        let frameX = (view.frame.size.width - snackbarWidth) / 2
        let hiddenFrame = CGRect(x: frameX, y: -60,
                                 width: snackbarWidth, height: 60)
        let shownFrame = CGRect(x: frameX, y: 50,
                                width: snackbarWidth, height: 60)

        self.view.addSubview(snackbarView)
        snackbarView.frame = hiddenFrame

        UIView.animate(withDuration: 0.5) {
            snackbarView.frame = shownFrame
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.5, delay: 3) {
                    snackbarView.frame = hiddenFrame
                } completion: { done in
                    if done {
                        snackbarView.removeFromSuperview()
                    }
                }
            }
        }
    }

}
