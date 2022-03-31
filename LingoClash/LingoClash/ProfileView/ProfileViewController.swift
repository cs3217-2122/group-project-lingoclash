//
//  ProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//
import UIKit
import Combine

import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var starsTodayLabel: UILabel!
    
    private let viewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBinders()
        viewModel.refreshProfile()
        
        
        // TODO: To be removed
        let bookDataManager = BookDataManager()
        let books = bookDataManager.getList()
        
        print("current user:", Auth.auth().currentUser ?? "")
        
        books.done { books in
            print("Profile Books fetched: ", books)
        }.catch { error in
            print("Profile Error: ", error)
        }
    }
    
    func setUpBinders() {
        
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }.store(in: &cancellables)
        
        viewModel.$name.sink {[weak self] name in
            if let name = name {
                self?.nameLabel.text = name
            }
        }.store(in: &cancellables)
        
        viewModel.$email.sink {[weak self] email in
            if let email = email {
                self?.emailLabel.text = email
            }
        }.store(in: &cancellables)
        
        viewModel.$totalStars.sink {[weak self] totalStars in
            if let totalStars = totalStars {
                self?.totalStarsLabel.text = "Total stars: \(totalStars)"
            }
        }.store(in: &cancellables)
        
        viewModel.$starsToday.sink {[weak self] starsToday in
            if let starsToday = starsToday {
                self?.starsTodayLabel.text = "Total stars today: \(starsToday)"
            }
        }.store(in: &cancellables)
        
        
        viewModel.$alertContent.sink {[weak self] alertContent in
            if let alertContent = alertContent {
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
        let splashViewController = SplashViewController.instantiateFromAppStoryboard(appStoryboard: AppStoryboard.Main)
        
        view.window?.rootViewController = splashViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        // TODO: Perhaps it is better to show as popup
        Logger.info("Error signing out: \(message)")
    }
    
}
