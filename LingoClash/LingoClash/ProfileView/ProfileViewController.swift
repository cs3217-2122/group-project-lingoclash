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

        setUpBinders()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopRefresh()
    }

    func setUpBinderForLabel(label: UILabel, publisher: Published<String?>.Publisher) {
        publisher.sink { value in
            if let value = value {
                label.text = value
            }
        }.store(in: &cancellables)
    }

    func setUpBinders() {
        let bindings: [UILabel: Published<String?>.Publisher] = [
            self.nameLabel: viewModel.$name,
            self.totalStarsLabel: viewModel.$totalStars,
            self.starsTodayLabel: viewModel.$starsToday,
            self.starsGoalLabel: viewModel.$starsGoal,
            self.rankingByTotalStarsLabel: viewModel.$rankingByTotalStars,
            self.daysLearningLabel: viewModel.$daysLearning,
            self.vocabsLearntLabel: viewModel.$vocabsLearnt,
            self.pkWinningRateLabel: viewModel.$pkWinningRate,
            self.bioLabel: viewModel.$bio
        ]

        for (label, publisher) in bindings {
            setUpBinderForLabel(label: label, publisher: publisher)
        }

        viewModel.$starsGoalProgress.sink {[weak self] starsGoalProgress in
            if let starsGoalProgress = starsGoalProgress {
                self?.starsGoalProgressView.progress = starsGoalProgress
                self?.starsGoalIcon.alpha = max(CGFloat(starsGoalProgress), 0.5)
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
