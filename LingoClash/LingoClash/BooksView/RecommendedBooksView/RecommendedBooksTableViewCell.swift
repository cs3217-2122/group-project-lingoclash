//
//  RecommendedBooksTableViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import UIKit

private let collectionCellReuseIdentifier = "RecommendedBookCollectionCell"


class RecommendedBooksTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var books: [String] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    func configure(books: [String]) {
        self.books = books
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseIdentifier, for: indexPath) as? RecommendedBookCollectionViewCell {
            
            bookCell.configure(bookName: books[indexPath.row])
            cell = bookCell
        }
        return cell
    }

}
