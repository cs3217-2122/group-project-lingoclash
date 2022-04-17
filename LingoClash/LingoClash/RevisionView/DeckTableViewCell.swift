//
//  DeckTableViewCell.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

import UIKit

class DeckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var vocabNoLabel: UILabel!
    //
//    // TODO: decide what kind of progress I want to do (number of words not done? or smth)
//    @IBOutlet weak var progressLabel: UILabel!
    
    
    func configure(deckName: String, vocabNo: String) {
        deckNameLabel.text = deckName
        vocabNoLabel.text = vocabNo
    }
}
