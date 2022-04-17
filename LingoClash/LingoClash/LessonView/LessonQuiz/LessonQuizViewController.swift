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
        static let toOutcomeVC = "toLessonQuizOutcomeViewController"
    }
    weak var questionViewController: QuestionViewController?

    var viewModel: LessonQuizViewModel? {
        didSet {
            fillUI()
        }
    }

    @IBOutlet private var livesLeftLabel: UILabel!
    @IBOutlet private var progressBar: LessonQuizProgressBarView!
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

        } else if segue.identifier == Segue.toOutcomeVC {
            guard let viewModel = viewModel,
                  let outcomeViewController = segue.destination as? LessonQuizOutcomeViewController else {
                return
            }
            outcomeViewController.viewModel = viewModel.quizOutcomeViewModel
        }

    }

    func styleUI() {

    }

    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        for position in viewModel.starPositions {
            self.progressBar.addStarView(at: position)

        }
        viewModel.progress.bindAndFire { [weak self] in
            self?.progressBar?.setProgress($0, animated: true)
        }
        viewModel.questionViewModel.bindAndFire { [weak self] _ -> Void in
            self?.questionViewController?.reloadData()
        }
        viewModel.quizStatus.bindAndFire { [weak self] in
            self?.navigateAfterQuizCompleted(quizStatus: $0)
        }
        viewModel.livesLeft.bindAndFire { [weak self] in
            self?.livesLeftLabel.text = String($0)
        }
    }

    func navigateAfterQuizCompleted(quizStatus: QuizStatus) {
        guard quizStatus != .incomplete else {
            return
        }
        performSegue(withIdentifier: Segue.toOutcomeVC, sender: self)
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
