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
    @IBOutlet weak var optionLabel: UILabel!
}
