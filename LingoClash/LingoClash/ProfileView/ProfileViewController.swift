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

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var totalStarsLabel: UILabel!
    @IBOutlet private var starsTodayLabel: UILabel!
    @IBOutlet private var starsGoalLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var daysLearningLabel: UILabel!
    @IBOutlet private var vocabsLearntLabel: UILabel!
    @IBOutlet private var pkWinningRateLabel: UILabel!
    @IBOutlet private var rankingByTotalStarsLabel: UILabel!
    @IBOutlet private var starsGoalProgressView: UIProgressView!
    @IBOutlet private var starsGoalIcon: UIImageView!

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
                self?.pkWinningRateLabel.text = String(format: "%.2f", pkWinningRate)
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
