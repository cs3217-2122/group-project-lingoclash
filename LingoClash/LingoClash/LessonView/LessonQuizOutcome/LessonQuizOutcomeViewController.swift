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
        static let unwindOutcomeToVocabVC = "unwindOutcomeToVocabVC"
    }

    let darkBackgroundColor = UIColor(red: 5.0/255, green: 44.0/255, blue: 79.0/255, alpha: 1)
    let lightBackgroundColor = UIColor(red: 3.0/255, green: 144.0/255, blue: 228.0/255, alpha: 1)
    
    @IBOutlet var stars: [StarView]!
    @IBOutlet weak var completionStatusLabel: UILabel!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var performanceCommentLabel: UILabel!
    @IBOutlet weak var vocabsLearntTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var actionButton: UIButton!

    @IBAction func onActionButtonTap(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {
            return
        }
        if viewModel.didPass {
            // TODO: perform segue to next lesson/level selector page
        } else {
            performSegue(withIdentifier: Segue.unwindOutcomeToVocabVC, sender: self)
        }
    }

    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    @IBOutlet weak var quizOutcomeLabel: UILabel!
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
        self.topView.backgroundColor = viewModel.isBackgroundDark ? darkBackgroundColor : lightBackgroundColor
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
