//
//  VocabCollectionCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit

class VocabCollectionCell: UICollectionViewCell {
    @IBOutlet private var vocabLabel: UILabel!
    @IBOutlet private var containerView: UIView!

    func configure(vocab: String?) {
        vocabLabel.text = vocab
        ViewUtilities.styleCard(contentView)
    }

}
