//
//  RecommendedBooksViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import UIKit

class RecommendedBooksViewController: UIViewController {

    @IBOutlet private var containerView: UIView!

    private let viewModel = RecommendedBooksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? RecommendedBooksTableViewController {
            collectionViewController.viewModel = self.viewModel
        }
    }
}
