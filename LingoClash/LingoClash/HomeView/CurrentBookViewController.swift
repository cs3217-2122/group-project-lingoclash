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
    // TODO: remove below
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    var viewModel: HomeViewModel?
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBinders()
    }
    
    func setUpView() {
        ViewUtilities.styleCard(containerView)
    }
    
    func setUpBinders() {
        viewModel?.$currentBook.sink {[weak self] book in
            if let book = book {
                self?.bookNameLabel.text = book.name
                self?.progressLabel.text = book.progress
            }
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lessonSelectionViewController = segue.destination as? LessonSelectionViewController {
            guard let lessonSelectionViewModel = self.viewModel?.lessonSelectionViewModel else {
                assert(false)
                return
            }
            lessonSelectionViewController.viewModel = lessonSelectionViewModel
        }
    }

}
