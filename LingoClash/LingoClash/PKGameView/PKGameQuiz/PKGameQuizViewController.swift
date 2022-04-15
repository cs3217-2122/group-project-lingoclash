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
        static let toOverviewViewController = "segueFromPKGameQuizToOverviewVC"
        static let unwindToPKGameLobby = "unwindToPKGameLobby"
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
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerTwoScore: UILabel!
    
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerOneScore: UILabel!
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        playerOneName.text = viewModel.playerNames[0]
        playerTwoName.text = viewModel.playerNames[1]
        viewModel.questionViewModel.bindAndFire { [unowned self] (_) -> Void in
            self.questionViewController?.reloadData() }
        viewModel.scores.bindAndFire { [unowned self] scores in
            playerOneScore.text = String(scores[0])
            playerTwoScore.text = String(scores[1])
        }
        viewModel.gameOverviewViewModel.bindAndFire { [unowned self] in
            self.navigateAfterQuizCompleted(vm: $0)
            
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
        } else if segue.identifier == Segue.unwindToPKGameLobby {
            viewModel?.forfeitGame()
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
