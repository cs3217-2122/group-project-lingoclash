//
//  SimpleOptionQuestionLayoutViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

import UIKit

class SimpleOptionQuestionLayoutViewController: UIViewController, QuestionLayoutViewController {
    static let identifier = "SimpleOptionQuestionLayoutVC"
    typealias VM = SimpleOptionQuestionLayoutViewModel
    let cellSpacingHeight:CGFloat = 10
    
    
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    var delegate: QuestionLayoutVCDelegate?
    
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        styleUI()
        fillUI()
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        
        viewModel.questionStatus.bindAndFire { [unowned self] in
            if $0 != .incomplete {
                delegate?.questionLayoutViewController(self, didAnswerCorrectly: $0 == .correct)
            }
        }
        self.contextLabel.text = viewModel.context
        optionsTableView.reloadData()
    }
}

extension SimpleOptionQuestionLayoutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.options.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: OptionTableCell.reuseIdentifier) as? OptionTableCell else {
            fatalError("Failure obtaining reusable option table view cell")
        }
        cell.optionText = viewModel?.options[indexPath.section] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension SimpleOptionQuestionLayoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectOption(at: indexPath.section)
    }
}
