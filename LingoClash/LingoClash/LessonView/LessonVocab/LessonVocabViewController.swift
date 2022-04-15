//
//  LessonVocabViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit

class LessonVocabViewController: UIViewController {
    @IBOutlet private var vocabLabel: UILabel!
    @IBOutlet private var sentenceDefinitionLabel: UILabel!
    @IBOutlet private var sentenceLabel: UILabel!
    @IBOutlet private var vocabDefinitionLabel: UILabel!
    @IBOutlet private var pronounciationLabel: UILabel!

    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var prevButton: UIButton!

    @IBAction private func playVocabPronounciation(_ sender: UIButton) {
        viewModel?.playVocabPronounciation()
    }

    @IBAction private func navigateToPreviousVocab(_ sender: UIButton) {
        viewModel?.navigatePrev()
    }

    @IBAction private func navigateToNextVocab(_ sender: UIButton) {
        viewModel?.navigateNext()
    }

    var viewModel: LessonVocabViewModel? {
        didSet {
            fillUI()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let viewModel = viewModel else {
            return
        }

        if let lessonQuizViewController = segue.destination as? LessonQuizViewController {
            lessonQuizViewController.viewModel = viewModel.lessonQuizViewModel
        }
    }

    @IBAction private func unwindToVocabs(segue: UIStoryboardSegue) {
        viewModel?.reload()
    }

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

        viewModel.currVocab.bindAndFire { [unowned self] in self.vocabLabel.text = $0 }
        viewModel.currSentenceDefinition.bindAndFire { [unowned self] in self.sentenceDefinitionLabel.text = $0 }
        viewModel.currSentence.bindAndFire { [unowned self] in self.sentenceLabel.text = $0 }
        viewModel.currVocabDefinition.bindAndFire { [unowned self] in self.vocabDefinitionLabel.text = $0 }
        viewModel.currVocabPronounciation.bindAndFire { [unowned self] in self.pronounciationLabel.text = $0 }
        viewModel.isLastVocab.bindAndFire { [unowned self] in self.nextButton.isEnabled = !$0 }
        viewModel.isFirstVocab.bindAndFire { [unowned self] in self.prevButton.isEnabled = !$0 }
    }
}
