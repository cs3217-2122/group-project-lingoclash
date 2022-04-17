//
//  RecommendedBookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class RecommendedBookCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var learnButton: UIButton!

    weak var delegate: LearnButtonDelegate?
    private(set) var lessonSelectionViewModel: LessonSelectionViewModel?
    private var book: Book?

    func configure(book: Book, delegate: LearnButtonDelegate?) {
        bookNameLabel.text = book.name
        self.delegate = delegate
        self.book = book

        self.lessonSelectionViewModel = LessonSelectionViewModelFromBook(book: book)
    }

    @IBAction private func learnButtonTapped(_ sender: UIButton) {
        guard let lessonSelectionViewModel = lessonSelectionViewModel, let book = book else {
            return
        }
        self.delegate?.learnButtonTapped(book: book, lessonSelectionVM: lessonSelectionViewModel)
    }
}
