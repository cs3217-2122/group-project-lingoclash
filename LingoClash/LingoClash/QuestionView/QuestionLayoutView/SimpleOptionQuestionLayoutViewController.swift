//
//  SimpleOptionQuestionLayoutViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

import UIKit

class SimpleOptionQuestionLayoutViewController: UIViewController, QuestionLayoutViewController {
    typealias VM = SimpleOptionQuestionLayoutViewModel
    let cellSpacingHeight: CGFloat = 10

    @IBOutlet private var contextLabel: UILabel!
    @IBOutlet private var optionsTableView: UITableView!
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
                handleQuestionCompletion($0)
            }
        }
        self.contextLabel.text = viewModel.context
        optionsTableView.reloadData()
    }

    private func handleQuestionCompletion(_ questionStatus: QuestionStatus) {
        guard questionStatus != .incomplete else {
            return
        }

        guard let viewModel = viewModel,
              let optionSelectedIndex = viewModel.optionSelectedIndex else {
            return
        }
        guard let correctCell = optionsTableView.cellForRow(
            at: IndexPath(row: 0, section: viewModel.answerIndex)) as? OptionTableCell,
              let cellSelected = optionsTableView.cellForRow(
                at: IndexPath(row: 0, section: optionSelectedIndex)) as? OptionTableCell else {
            return
        }

        UIView.animate(withDuration: 0.7,
                       animations: {
            correctCell.backgroundColor = Theme.current.green
            correctCell.optionLabel.textColor = .white
            if questionStatus == .wrong {
                cellSelected.backgroundColor = Theme.current.errorContainer
                cellSelected.optionLabel.textColor = Theme.current.errorText
            }
        }, completion: { [self] _ -> Void in
            delegate?.questionLayoutViewController(self, didAnswerCorrectly: questionStatus == .correct)
        })

    }
}

extension SimpleOptionQuestionLayoutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.options.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: OptionTableCell.reuseIdentifier) as? OptionTableCell else {
            fatalError("Failure obtaining reusable option table view cell")
        }
        cell.optionText = viewModel?.options[indexPath.section] ?? ""
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
//        headerView.backgroundColor = Theme.current.tertiary
        return headerView
    }
}

extension SimpleOptionQuestionLayoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard viewModel?.optionSelectedIndex == nil else {
            return nil
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectOption(at: indexPath.section)
    }
}
