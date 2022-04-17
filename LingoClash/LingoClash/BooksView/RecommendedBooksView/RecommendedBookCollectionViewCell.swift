//
//  RecommendedBookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class RecommendedBookCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var bookNameLabel: UILabel!
    @IBOutlet private var learnButton: UIButton!

    weak var delegate: LearnButtonDelegate?
    private var book: Book?

    func configure(book: Book, delegate: LearnButtonDelegate?) {
        bookNameLabel.text = book.name
        self.delegate = delegate
        ViewUtilities.styleCard(containerView)
        self.book = book
    }

    @IBAction private func learnButtonTapped(_ sender: UIButton) {
        guard let book = book else {
            return
        }
        self.delegate?.learnButtonTapped(book: book)
    }
}
