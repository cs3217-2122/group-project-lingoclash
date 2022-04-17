//
//  RecommendedBooksTableViewCell.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import UIKit

private let collectionCellReuseIdentifier = "RecommendedBookCollectionCell"

class RecommendedBooksTableViewCell: UITableViewCell {

    private var books = [Book]()
    private weak var delegate: LearnButtonDelegate?

    @IBOutlet private var collectionView: UICollectionView!

    func configure(books: [Book], delegate: LearnButtonDelegate) {
        self.books = books
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.delegate = delegate
    }
}

extension RecommendedBooksTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()
        if let bookCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionCellReuseIdentifier,
            for: indexPath) as? RecommendedBookCollectionViewCell {
            bookCell.configure(book: books[indexPath.row], delegate: delegate)

            cell = bookCell
        }
        return cell
    }
}
