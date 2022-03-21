//
//  CollectionViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit
import Combine

private let cellReuseIdentifier = "RecommendedBookCell"
private let headerReuseIdentifer = "CategoryHeader"

class RecommendedBookCollectionViewController: UICollectionViewController {
    var booksWithCategories: BooksWithCategories = BooksWithCategories()
    var viewModel: RecommendedBooksViewModel?
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
        
        viewModel.$booksWithCategories.sink {[weak self] books in
            self?.booksWithCategories = books
        }.store(in: &cancellables)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return booksWithCategories.categories.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = booksWithCategories.categories[section]
        return booksWithCategories.books[category]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? RecommendedBookCollectionViewCell {
            let category = booksWithCategories.categories[indexPath.section]
            let books = booksWithCategories.books[category] ?? []
            bookCell.configure(bookName: books[indexPath.row])
            cell = bookCell
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let categoryHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifer, for: indexPath) as? CategoryHeaderReusableView {
            categoryHeader.categoryLabel.text = booksWithCategories.categories[indexPath.section]
            return categoryHeader
        }
        return UICollectionReusableView()
    }
    
}
