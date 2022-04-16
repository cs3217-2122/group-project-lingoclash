//
//  LearningBooksViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 20/3/22.
//

import UIKit

class LearningBooksViewController: UIViewController {

    @IBOutlet private var containerView: UIView!

    private let viewModel = LearningBooksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? BookCollectionViewController {
            collectionViewController.viewModel = self.viewModel
            collectionViewController.parentVC = self
        }
    }
}
