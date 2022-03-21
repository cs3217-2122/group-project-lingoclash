//
//  BookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var PKButton: UIButton!
    @IBOutlet weak var reviseButton: UIButton!
    @IBOutlet weak var learnButton: UIButton!
    
    func configure(bookName: String, progress: String) {
        bookNameLabel.text = bookName
        progressLabel.text = progress
    }
}
