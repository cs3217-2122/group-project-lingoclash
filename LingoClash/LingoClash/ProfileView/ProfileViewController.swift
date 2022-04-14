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
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var starsTodayLabel: UILabel!
    @IBOutlet weak var starsGoalLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var daysLearningLabel: UILabel!
    @IBOutlet weak var vocabsLearntLabel: UILabel!
    @IBOutlet weak var pkWinningRateLabel: UILabel!
    @IBOutlet weak var rankingByTotalStarsLabel: UILabel!
    @IBOutlet weak var starsGoalProgressView: UIProgressView!
    @IBOutlet weak var starsGoalIcon: UIImageView!

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
        
        viewModel.$starsGoal.sink {[weak self] starsGoal in
            if let starsGoal = starsGoal {
                self?.starsGoalLabel.text = "\(starsGoal)"
            }
        }.store(in: &cancellables)
        
        viewModel.$rankingByTotalStars.sink {[weak self] rankingByTotalStars in
            if let rankingByTotalStars = rankingByTotalStars {
                self?.rankingByTotalStarsLabel.text = "\(rankingByTotalStars)"
            }
        }.store(in: &cancellables)
        
        viewModel.$daysLearning.sink {[weak self] daysLearning in
            if let daysLearning = daysLearning {
                self?.daysLearningLabel.text = "\(daysLearning)"
            }
        }.store(in: &cancellables)
        
        viewModel.$vocabsLearnt.sink {[weak self] vocabsLearnt in
            if let vocabsLearnt = vocabsLearnt {
                self?.vocabsLearntLabel.text = "\(vocabsLearnt)"
            }
        }.store(in: &cancellables)
        
        viewModel.$pkWinningRate.sink {[weak self] pkWinningRate in
            if let pkWinningRate = pkWinningRate {
                self?.pkWinningRateLabel.text = "\(pkWinningRate)"
            }
        }.store(in: &cancellables)
        
        viewModel.$starsGoalProgress.sink {[weak self] starsGoalProgress in
            if let starsGoalProgress = starsGoalProgress {
                self?.starsGoalProgressView.progress = starsGoalProgress
                self?.starsGoalIcon.alpha = max(CGFloat(starsGoalProgress), 0.5)
            }
        }.store(in: &cancellables)
        
        viewModel.$bio.sink {[weak self] bio in
            if let bio = bio {
                self?.bioLabel.text = "\"\(bio)\""
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
