//
//  LessonOverviewViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit
import CoreGraphics

class LessonOverviewViewController: UIViewController {

    var viewModel: LessonOverviewViewModel? {
        didSet {
            fillUI()
        }
    }

    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 50.0,
                                             bottom: 50.0,
                                             right: 50.0)
    private let itemsPerRow = CGFloat(3)

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var vocabCollection: UICollectionView!
    @IBAction private func startLesson(_ sender: UIButton) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vocabCollection.dataSource = self
        styleUI()
        fillUI()
    }

    func styleUI() {
        let alignedFlowLayout = collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
    }

    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        let label = UILabel()
        label.text = viewModel.lessonName
        self.navigationItem.titleView = label

        viewModel.vocabs.bindAndFire {[unowned self] _ -> Void in
            vocabCollection.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let viewModel = viewModel else {
            return
        }

        if let lessonVocabViewController = segue.destination as? LessonVocabViewController {
            lessonVocabViewController.viewModel = viewModel.lessonVocabViewModel
        }
    }
}

extension LessonOverviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.vocabs.value.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppConfigs.View.vocabCollectionCellIdentifier,
            for: indexPath)

        if let cell = cell as? VocabCollectionCell {
            cell.configure(vocab: viewModel?.vocabs.value[indexPath.row])
        }

        return cell
    }
}
