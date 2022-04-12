//
//  RecommendedBookCollectionViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class RecommendedBookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var learnButton: UIButton!
    
    weak var delegate: LearnButtonDelegate?
    private(set) var lessonSelectionViewModel: LessonSelectionViewModel?
    
    func configure(book: Book, delegate: LearnButtonDelegate?) {
        bookNameLabel.text = book.name
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
