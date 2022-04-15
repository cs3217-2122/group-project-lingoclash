//
//  OptionTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import UIKit

class OptionTableCell: UITableViewCell {
    static let reuseIdentifier = "optionTableCell"
    var optionText: String = "" {
        didSet {
            self.optionLabel.text = optionText
        }
    }
    @IBOutlet var optionLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 1.0
    }
}
