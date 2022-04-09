//
//  UIViewController+Spinner.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 8/4/22.
//

import UIKit

private var spinnerView: UIView?

extension UIViewController {

    func showSpinner() {
        let activityView = UIView(frame: self.view.bounds)
        let activityIndicator = UIActivityIndicatorView(
            style: .large)
        activityIndicator.center = activityView.center
        activityIndicator.startAnimating()
        activityView.addSubview(activityIndicator)
        activityView.backgroundColor = .white
        activityView.alpha = 0.3
        self.view.addSubview(activityView)
        spinnerView = activityView
    }

    func removeSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }

}
