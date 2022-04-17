//
//  PKGameQuizViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import UIKit
import simd

class PKGameQuizViewController: UIViewController {
    enum Segue {
        static let toQuestionViewController = "segueFromPKGameQuizToQuestionVC"
        static let toOverviewViewController = "segueFromPKGameQuizToOverviewVC"
        static let unwindFromPKGameQuizToHome = "unwindFromPKGameQuizToHome"
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
    @IBOutlet private var playerTwoName: UILabel!
    @IBOutlet private var playerTwoScore: UILabel!

    @IBOutlet private var playerOneName: UILabel!
    @IBOutlet private var playerOneScore: UILabel!
    func styleUI() {

    }

    @IBAction private func forfeit(_ sender: Any) {
        print("did click forfeit")
        let forfeitConfirmation = UIAlertController(
            title: "Forfeit",
            message: "Forfeit in cowardice? Are you sure?",
            preferredStyle: .alert)

         // Create OK button with action handler
         let proceed = UIAlertAction(title: "A Coward I am.", style: .default, handler: { _ -> Void in
             self.viewModel?.forfeitGame()
          })
        let cancel = UIAlertAction(title: "Stay and fight!", style: .cancel, handler: { _ -> Void in
            })

        forfeitConfirmation.addAction(proceed)
        forfeitConfirmation.addAction(cancel)
        self.present(forfeitConfirmation, animated: true, completion: nil)

    }

    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        playerOneName.text = viewModel.playerNames[0]
        playerTwoName.text = viewModel.playerNames[1]
        viewModel.questionViewModel.bindAndFire { [weak self] _ -> Void in
            self?.questionViewController?.reloadData()
        }
        viewModel.scores.bindAndFire { [weak self] scores in
            self?.playerOneScore.text = String(scores[0])
            self?.playerTwoScore.text = String(scores[1])
        }
        viewModel.gameOverviewViewModel.bindAndFire { [weak self] in
            self?.navigateAfterQuizCompleted(vm: $0)

        }
    }

    func navigateAfterQuizCompleted(vm: PKGameOverviewViewModel?) {
        guard vm != nil else {
            return
        }
        performSegue(withIdentifier: Segue.toOverviewViewController, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toQuestionViewController {
            guard let questionViewController = segue.destination as? QuestionViewController else {
                return
            }
            self.questionViewController = questionViewController
            questionViewController.datasource = self
            questionViewController.delegate = self

        } else if segue.identifier == Segue.toOverviewViewController {
            guard let gameOverviewViewModel = viewModel?.gameOverviewViewModel.value,
                  let outcomeViewController = segue.destination as? PKGameOverviewViewController else {
                return
            }
            outcomeViewController.viewModel = gameOverviewViewModel
        }
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
