//
//  AlertUtilities.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import UIKit

class AlertUtilities {
    static func createConfirmAlert(
        title: String,
        message: String,
        confirmHandler: ((UIAlertAction) -> Void)?
    ) -> UIAlertController {
        let alert = AlertUtilities.createAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: confirmHandler))
        return alert
    }

    static func createDoneAlert(
        title: String,
        message: String,
        doneHandler: ((UIAlertAction) -> Void)?
    ) -> UIAlertController {
        let alert = AlertUtilities.createAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: doneHandler))
        return alert
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
