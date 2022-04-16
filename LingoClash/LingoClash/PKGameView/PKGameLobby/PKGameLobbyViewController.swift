//
//  PKGameLobbyViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import UIKit

class PKGameLobbyViewController: UIViewController {
    enum Segue {
        static let toHomeViewController = "unwindPKGameLobbyToHomeVC"
        static let toPKGameQuizViewController = "segueFromLobbyToQuizVC"
    }
    typealias VM = PKGameLobbyViewModel
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

        viewModel.pkGameQuizViewModel.bind { [self] _ -> Void in
            self.startPKGame()
        }

        viewModel.findMatch()
    }

    private func startPKGame() {
        guard self.viewModel?.pkGameQuizViewModel.value != nil else {
            return
        }
        performSegue(withIdentifier: Segue.toPKGameQuizViewController, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pkQuizVC = segue.destination as? PKGameQuizViewController {
            guard let pkQuizVM = self.viewModel?.pkGameQuizViewModel.value else {
                return
            }
            pkQuizVC.viewModel = pkQuizVM
        }
    }

    @IBAction private func unwindToPKGameLobby(segue: UIStoryboardSegue) {
        viewModel?.findMatch()
    }

    @IBAction private func cancel(_ sender: UIButton) {
        // tell view model to cancel the find
        viewModel?.cancel()
        // segue to home
        performSegue(withIdentifier: Segue.toHomeViewController, sender: self)
    }
}
