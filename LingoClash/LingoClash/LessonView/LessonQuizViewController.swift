//
//  LessonVocabViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit

class LessonQuizViewController: UIViewController {
    enum Segue {
        static let toQuestionViewController = "segueToQuestionViewController"
    }
    weak var questionViewController: QuestionViewController?
    
    var viewModel: LessonQuizViewModel? {
        didSet {
            fillUI()
        }
    }

    @IBOutlet weak var progressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
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
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        viewModel.progress.bindAndFire { [unowned self] in
            self.progressBar?.setProgress($0, animated: true) }
        viewModel.questionViewModel.bindAndFire { [unowned self] (_) -> Void in
            self.questionViewController?.reloadData() }
        viewModel.quizStatus.bindAndFire { [unowned self] in
            self.navigateAfterQuizCompleted(quizStatus: $0) }
    }
    
    func navigateAfterQuizCompleted(quizStatus: QuizStatus) {
        guard quizStatus != .incomplete else {
            return
        }
        navigationController?.popViewController(animated: true)
    }
}

extension LessonQuizViewController: QuestionViewControllerDataSource {
    func setViewModel(_: QuestionViewController) -> QuestionViewModel? {
        viewModel?.questionViewModel.value
    }
}

extension LessonQuizViewController: QuestionViewControllerDelegate {
    func questionViewController(_: QuestionViewController, didAnswerCorrectly: Bool) {
        viewModel?.questionDidComplete(isCorrect: didAnswerCorrectly)
    }
    
    
}
