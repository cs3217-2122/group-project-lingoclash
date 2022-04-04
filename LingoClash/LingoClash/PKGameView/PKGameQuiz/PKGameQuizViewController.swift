//
//  PKGameQuizViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import UIKit

class PKGameQuizViewController: UIViewController {
    enum Segue {
        static let toQuestionViewController = "segueFromPKGameQuizToQuestionVC"
    }
    typealias VM = PKGameQuizViewModel
    weak var questionViewController: QuestionViewController?

    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
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
        viewModel.questionViewModel.bindAndFire { [unowned self] (_) -> Void in
            self.questionViewController?.reloadData() }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toQuestionViewController {
            guard let questionViewController = segue.destination as? QuestionViewController else {
                return
            }
            self.questionViewController = questionViewController
            questionViewController.datasource = self
            questionViewController.delegate = self
            
        }
        // TODO: Add segue logic to Outcome
    }
}

extension PKGameQuizViewController: QuestionViewControllerDataSource {
    func setViewModel(_: QuestionViewController) -> QuestionViewModel? {
        viewModel?.questionViewModel.value
    }
}

extension PKGameQuizViewController: QuestionViewControllerDelegate {
    func questionViewController(_: QuestionViewController, didAnswerCorrectly: Bool) {
        viewModel?.questionDidComplete(isCorrect: didAnswerCorrectly)
    }
    
    
}
