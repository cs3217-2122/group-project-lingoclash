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
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var PKButton: UIButton!
    @IBOutlet weak var reviseButton: UIButton!
    @IBOutlet weak var learnButton: UIButton!
    
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
    
    @IBAction func learnButtonTapped(_ sender: UIButton) {
        guard let lessonSelectionViewModel = lessonSelectionViewModel else {
            return
        }
        self.delegate?.learnButtonTapped(lessonSelectionVM: lessonSelectionViewModel)
    }
    
}
