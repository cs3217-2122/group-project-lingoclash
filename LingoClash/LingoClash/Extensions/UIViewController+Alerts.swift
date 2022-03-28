//
//  UIViewController+Extensions.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(title: String, message: String) {
        
        let alert = AlertUtilities.createAlert(title: title, message: message)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(title: String, message: String, confirmHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = AlertUtilities.createConfirmAlert(title: title, message: message, confirmHandler: confirmHandler)
        
        self.present(alert, animated: true, completion: nil)
    }
}
