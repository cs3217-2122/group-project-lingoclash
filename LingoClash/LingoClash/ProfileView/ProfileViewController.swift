//
//  ProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBinders()
    }
    
    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }.store(in: &cancellables)
        
        
        viewModel.$alertContent.sink {[weak self] alertContent in
            if let alertContent = alertContent {
                //                self?.showAlert(alertContent)
                self?.showConfirmAlert(title: alertContent.title, message: alertContent.message) { _ in
                    self?.transitionToSplash()
                }
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        viewModel.signOut()
    }
    
    func transitionToSplash() {
        let splashViewController = storyboard?.instantiateViewController(withIdentifier: AppConfigs.StoryBoard.splashVC) as? SplashViewController
        
        view.window?.rootViewController = splashViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        // TODO: Perhaps it is better to show as popup
        Logger.info("Error signing out: \(message)")
    }
    
}
