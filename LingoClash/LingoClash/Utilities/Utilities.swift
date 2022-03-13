//
//  Utilities.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

class Utilities {
    static func isEmailValid(_ password: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: password)
    }
    
    /// Check if password has at least 8 characters, contains a special character and a number.
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    static func getTrimmedString(textField: UITextField) -> String {
        textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)

        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)],
                                      range: NSRange(location: 0, length: title.utf8.count))

        let attributedMessage = NSMutableAttributedString(string: message)
        attributedMessage.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                        range: NSRange(location: 0, length: message.utf8.count))

        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        return alert
    }
    
}
