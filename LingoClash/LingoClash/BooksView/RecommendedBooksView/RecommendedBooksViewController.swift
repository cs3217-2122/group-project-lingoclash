//
//  RecommendedBooksViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 21/3/22.
//

import UIKit

class RecommendedBooksViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private let viewModel = RecommendedBooksViewModel()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionViewController = segue.destination as? RecommendedBookCollectionViewController {
            collectionViewController.viewModel = self.viewModel
        }
    }
}
