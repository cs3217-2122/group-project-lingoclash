//
//  AddToDeckTableViewCell.swift
//  LingoClash
//
//  Created by kevin chua on 17/4/22.
//

import Foundation
import UIKit

class AddToDeckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deckNameLabel: UILabel!
    
    func configure(deckName: String) {
        deckNameLabel.text = deckName
    }
}
