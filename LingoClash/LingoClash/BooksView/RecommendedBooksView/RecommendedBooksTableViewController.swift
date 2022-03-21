//
//  RecommendedBooksTableViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import UIKit
import Combine

private let tableCellReuseIdentifier = "RecommendedBookTableCell"
private let headerReuseIdentifer = "CategoryHeader"

class RecommendedBooksTableViewController: UITableViewController {
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return booksWithCategories.categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let booksCell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as? RecommendedBooksTableViewCell {
            
            let category = booksWithCategories.categories[indexPath.section]
            booksCell.configure(books: booksWithCategories.books[category] ?? [])
            cell = booksCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return booksWithCategories.categories[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    

}
