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
    
    @IBOutlet weak var descriptionOutcome: UILabel!
    @IBOutlet weak var titleOutcome: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoScore: UILabel!
    @IBOutlet weak var playerOneScore: UILabel!
    @IBOutlet weak var topView: UIView!
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
        topView.backgroundColor = viewModel.isBackgroundDark ? Theme.current.secondary : Theme.current.primary

        playerOneName.text = viewModel.names[0]
        playerTwoName.text = viewModel.names[1]
        playerOneScore.text = viewModel.scores[0]
        playerTwoScore.text = viewModel.scores[1]

    }
}
