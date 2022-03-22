//
//  LessonQuizOutcomeViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

import UIKit

class LessonQuizOutcomeViewController: UIViewController {
    typealias VM = LessonQuizOutcomeViewModel
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    @IBOutlet weak var quizOutcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        self.quizOutcomeLabel.text = viewModel.quizOutcome
        view.backgroundColor = viewModel.didPass ? .systemGreen : .systemRed
    }
}
