//
//  VocabsLearntTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

import UIKit

class VocabsLearntTableCell: UITableViewCell {
    static let reuseIdentifier = "vocabsLearntTableCell"
    var vocabWord: String = "" {
        didSet {
            self.vocabWordLabel.text = vocabWord
        }
    }
    @IBOutlet private var vocabWordLabel: UILabel!
}
