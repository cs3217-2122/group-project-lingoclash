//
//  DevLoginTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 13/4/22.
//

import UIKit

class DevLoginTableCell: UITableViewCell {
    static let reuseIdentifier = "devLoginTableCellIdentifier"
    var email: String? {
        didSet {
            if let email = email {
                self.emailLabel.text = email
            }
        }
    }
    @IBOutlet private var emailLabel: UILabel!
}
