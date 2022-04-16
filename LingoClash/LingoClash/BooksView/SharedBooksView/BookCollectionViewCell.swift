//
//  BookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var bookNameLabel: UILabel!
    @IBOutlet private var progressLabel: UILabel!
    @IBOutlet private var totalStarsLabel: UILabel!
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var PKButton: UIButton!
    @IBOutlet private var reviseButton: UIButton!
    @IBOutlet private var learnButton: UIButton!

    weak var delegate: BookButtonDelegate?
    private(set) var lessonSelectionViewModel: LessonSelectionViewModel?

    func configure(book: Book, delegate: BookButtonDelegate) {
        bookNameLabel.text = book.name
        progressLabel.text = book.progressText
        totalStarsLabel.text = "\(book.totalStars)"
        progressView.progress = book.progress

        self.delegate = delegate
        self.lessonSelectionViewModel = LessonSelectionViewModelFromBook(book: book)
    }

    @IBAction private func learnButtonTapped(_ sender: UIButton) {
        guard let lessonSelectionViewModel = lessonSelectionViewModel else {
            return
        }
        self.delegate?.learnButtonTapped(lessonSelectionVM: lessonSelectionViewModel)
    }

}
