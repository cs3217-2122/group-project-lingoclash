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
    var booksProgress: [BookProgress] = []
    var viewModel: BooksViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
        viewModel?.refreshBooks()
    }
    
    func setUpBinders() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.booksProgressPublisher.sink {[weak self] booksProgress in
            self?.booksProgress = booksProgress
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksProgress.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell {
            
            bookCell.configure(bookName: booksProgress[indexPath.row].name, progress: booksProgress[indexPath.row].progress)
            
            ViewUtilities.styleCard(bookCell)
            
            cell = bookCell
        }
        
        return cell
    }

}
