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
//    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var starsTodayLabel: UILabel!
    
    private let viewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refresh()
        setUpBinders()
    }
    
    func setUpBinders() {
        viewModel.$name.sink {[weak self] name in
            if let name = name {
                self?.nameLabel.text = name
            }
        }.store(in: &cancellables)
        
//        viewModel.$email.sink {[weak self] email in
//            if let email = email {
//                self?.emailLabel.text = email
//            }
//        }.store(in: &cancellables)
        
        viewModel.$totalStars.sink {[weak self] totalStars in
            if let totalStars = totalStars {
                self?.totalStarsLabel.text = "\(totalStars)"
            }
        }.store(in: &cancellables)
        
        viewModel.$starsToday.sink {[weak self] starsToday in
            if let starsToday = starsToday {
                self?.starsTodayLabel.text = "\(starsToday)"
            }
        }.store(in: &cancellables)
        
        viewModel.$isRefreshing.sink {[weak self] isRefreshing in
            if isRefreshing {
                self?.showSpinner()
            } else {
                self?.removeSpinner()
            }
        }.store(in: &cancellables)
    }
}
