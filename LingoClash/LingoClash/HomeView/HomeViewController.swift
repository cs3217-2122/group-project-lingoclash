//
//  HomeViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit

class HomeViewController: UIViewController {
    typealias VM = HomeViewModel
    let viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pkLobbyVC = segue.destination as? PKGameLobbyViewController {
            guard let pkLobbyVM = self.viewModel.pkGameLobbyViewModel else {
                return
            }
            pkLobbyVC.viewModel = pkLobbyVM
        }
    }

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        self.viewModel.refreshProfile()
    }
}
