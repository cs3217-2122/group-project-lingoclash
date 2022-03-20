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
    
    @IBOutlet weak var vocabCollection: UICollectionView!
    @IBAction func startLesson(_ sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vocabCollection.dataSource = self
        // TODO: REMOVE TEMPORARY
        self.viewModel = LessonOverviewViewModelFromLesson(lesson: Lesson(lessonName: "Lesson 1", lessonId: 1, stars: 0))
        styleUI()
        fillUI()
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        let textField = UITextField()
        textField.text = viewModel.lessonName
        self.navigationItem.titleView = textField

        viewModel.vocabs.bindAndFire {[unowned self] (_) -> Void in
            vocabCollection.reloadData()}
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.UI.vocabCollectionCellIdentifier,
            for: indexPath) as! VocabCollectionCell
        cell.textField.text = viewModel?.vocabs.value[indexPath.row]
        return cell
    }
    
    
}
//
//extension LessonOverviewViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//      // 2
//      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//      let availableWidth = view.frame.width - paddingSpace
//      let widthPerItem = availableWidth / itemsPerRow
//
//      return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      insetForSectionAt section: Int
//    ) -> UIEdgeInsets {
//      return sectionInsets
//    }
//
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//      return sectionInsets.left
//    }
//}
