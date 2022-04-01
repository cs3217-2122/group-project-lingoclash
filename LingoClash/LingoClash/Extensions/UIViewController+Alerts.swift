//
//  UIViewController+Extensions.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(content: AlertContent) {
        
        let alert = AlertUtilities.createAlert(title: content.title, message: content.message)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(content: AlertContent, confirmHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = AlertUtilities.createConfirmAlert(title: content.title, message: content.message, confirmHandler: confirmHandler)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDoneAlert(content: AlertContent, doneHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = AlertUtilities.createDoneAlert(title: content.title, message: content.message, doneHandler: doneHandler)
        
        self.present(alert, animated: true, completion: nil)
    }
}
