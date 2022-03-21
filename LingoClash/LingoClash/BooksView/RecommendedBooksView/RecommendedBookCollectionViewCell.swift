//
//  RecommendedBookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class RecommendedBookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var learnButton: UIButton!
    
    func configure(bookName: String) {
        bookNameLabel.text = bookName
    }
}
