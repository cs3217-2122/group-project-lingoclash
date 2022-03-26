//
//  LessonSelectionViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

import UIKit

class LessonSelectionViewController: UIViewController {
    typealias VM = LessonSelectionViewModel
    let cellSpacingHeight: CGFloat = 10
    enum Segue {
        static let selectorToOverview = "selectorToOverview"
    }
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    @IBOutlet weak var levelsPassedLabel: UILabel!
    @IBOutlet weak var starsObtainedLabel: UILabel!
    @IBOutlet weak var lessonsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LessonSelectionViewModelFromBook(book: Book(id: "awdawd", category_id: "dawdawd", name: "ho"))
        lessonsTableView.dataSource = self
        lessonsTableView.delegate = self
        styleUI()
        fillUI()
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        
        viewModel.starsObtained.bindAndFire { [unowned self] in
            self.starsObtainedLabel.text = $0
        }
        viewModel.levelsPassed.bindAndFire { [unowned self] in
            self.levelsPassedLabel.text = $0
        }
        viewModel.lessonTableViewModels.bindAndFire { [unowned self] (_) -> Void in
            self.lessonsTableView.reloadData()
        }
        viewModel.lessonOverviewViewModel.bind{ [unowned self] in
            transitionToLessonOverview(viewModel: $0)
        }
    }
    
    func transitionToLessonOverview(viewModel: LessonOverviewViewModel?) {
        guard viewModel != nil else {
            return
        }
        performSegue(withIdentifier: Segue.selectorToOverview, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let overviewVC = segue.destination as? LessonOverviewViewController {
            guard let overviewViewModel = self.viewModel?.lessonOverviewViewModel.value else {
                return
            }
            overviewVC.viewModel = overviewViewModel
        }
    }
    
    @IBAction func unwindToSelection(segue: UIStoryboardSegue) {
        viewModel?.reloadLessons()
    }
}

extension LessonSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.lessonTableViewModels.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: LessonSelectorTableCell.reuseIdentifier) as? LessonSelectorTableCell else {
            fatalError("Failure obtaining reusable lesson table view cell")
        }

        cell.viewModel = viewModel?.lessonTableViewModels.value[indexPath.section]
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

extension LessonSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectLevel(at: indexPath.section)
    }
}