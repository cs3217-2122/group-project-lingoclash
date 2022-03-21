//
//  CurrentBookViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit
import Combine

class CurrentBookViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    private let viewModel = CurrentBookViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBinders()
        viewModel.refresh()
    }
    
    func setUpView() {
        ViewUtilities.styleCard(containerView)
    }
    
    func setUpBinders() {
        viewModel.$currentBookProgress.sink {[weak self] bookProgress in
            if let bookProgress = bookProgress {
                self?.bookNameLabel.text = bookProgress.name
                self?.progressLabel.text = "Progress: \(bookProgress.progress)"
            }
        }.store(in: &cancellables)
    }

}
