//
//  PKGameOverviewViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import UIKit

class PKGameOverviewViewController: UIViewController {
    typealias VM = PKGameOverviewViewModel
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }

    @IBOutlet private var descriptionOutcome: UILabel!
    @IBOutlet private var titleOutcome: UILabel!
    @IBOutlet private var playerTwoName: UILabel!
    @IBOutlet private var playerOneName: UILabel!
    @IBOutlet private var playerTwoScore: UILabel!
    @IBOutlet private var playerOneScore: UILabel!
    @IBOutlet private var topImageView: UIImageView!
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
        titleOutcome.text = viewModel.titleOutcome
        descriptionOutcome.text = viewModel.descriptionOutcome
        topImageView.image = viewModel.isBackgroundDark ? #imageLiteral(resourceName: "cover_5") : #imageLiteral(resourceName: "cover_2")

        playerOneName.text = viewModel.names[0]
        playerTwoName.text = viewModel.names[1]
        playerOneScore.text = viewModel.scores[0]
        playerTwoScore.text = viewModel.scores[1]

    }
}
