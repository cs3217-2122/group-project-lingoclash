//
//  LessonQuizOutcomeViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

import UIKit

class LessonQuizOutcomeViewController: UIViewController {
    typealias VM = LessonQuizOutcomeViewModel

    enum Segue {
        static let outcomeToVocabVC = "outcomeToVocabVC"
        static let outcomeToLessonSelection = "outcomeToLessonSelection"
    }

    @IBOutlet private var stars: [StarView]!
    @IBOutlet private var completionStatusLabel: UILabel!
    @IBOutlet private var lessonNameLabel: UILabel!
    @IBOutlet private var performanceCommentLabel: UILabel!
    @IBOutlet private var vocabsLearntTableView: UITableView!
    @IBOutlet private var topView: UIView!
    @IBOutlet private var actionButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectionVC = segue.destination as? LessonSelectionViewController,
           let viewModel = viewModel {
            viewModel.updateLessonSelection(viewController: selectionVC)
        }
    }
    
    @IBAction private func onActionButtonTap(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {
            return
        }
        if viewModel.didPass {
            performSegue(withIdentifier: Segue.outcomeToLessonSelection, sender: self)
        } else {
            performSegue(withIdentifier: Segue.outcomeToVocabVC, sender: self)
        }
    }

    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }

    @IBOutlet private var quizOutcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vocabsLearntTableView.dataSource = self
        styleUI()
        fillUI()
    }

    func styleUI() {

    }

    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        self.completionStatusLabel.text = viewModel.completedStatus
        self.lessonNameLabel.text = viewModel.lessonName
        self.performanceCommentLabel.text = viewModel.performanceComment
        viewModel.starsFilled.enumerated().forEach { stars[$0.offset].isFilled = $0.element }
        self.topView.backgroundColor = viewModel.isBackgroundDark ? Theme.current.secondary : Theme.current.primary
        self.actionButton.titleLabel?.text = viewModel.actionText
    }
}

extension LessonQuizOutcomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.vocabsLearnt.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: VocabsLearntTableCell.reuseIdentifier) as? VocabsLearntTableCell else {
            fatalError("Failure obtaining reusable vocabs learnt table view cell")
        }

        cell.vocabWord = viewModel?.vocabsLearnt[indexPath.row] ?? ""
        return cell
    }
}
