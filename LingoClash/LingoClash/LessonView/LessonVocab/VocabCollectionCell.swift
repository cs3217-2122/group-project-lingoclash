//
//  VocabCollectionCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit

class VocabCollectionCell: UICollectionViewCell {
    @IBOutlet weak var vocabLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func configure(vocab: String?) {
        vocabLabel.text = vocab
        vocabLabel.sizeToFit()
        ViewUtilities.styleCard(contentView)
    }
}
