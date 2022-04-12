//
//  BookCollectionViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit
import Combine

private let reuseIdentifier = "BookCell"

class BookCollectionViewController: UICollectionViewController {
    var books: [Book] = []
    var viewModel: BooksViewModel?
    weak var parentVC: UIViewController?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
        viewModel?.refresh()
    }
    
    func setUpBinders() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.booksPublisher.sink {[weak self] books in
            self?.books = books
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.isRefreshingPublisher.sink {[weak self] isRefreshing in
            if isRefreshing {
                self?.parentVC?.showSpinner()
            } else {
                self?.parentVC?.removeSpinner()
            }
        }.store(in: &cancellables)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell {
            
            bookCell.configure(book: books[indexPath.row], delegate: self)
            
            ViewUtilities.styleCard(bookCell)
            
            cell = bookCell
        }
        
        return cell
    }
}

extension BookCollectionViewController: BookButtonDelegate {
    func learnButtonTapped(lessonSelectionVM: LessonSelectionViewModel) {
        let viewController = LessonSelectionViewController.instantiateFromAppStoryboard(.Lesson)
        viewController.viewModel = lessonSelectionVM
        self.show(viewController, sender: nil)
    }
}


