//
//  LessonVocabViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import UIKit

class LessonVocabViewController: UIViewController {
    @IBOutlet weak var vocabTextField: UITextField!
    @IBOutlet weak var sentenceDefinitionTextField: UITextField!
    @IBOutlet weak var sentenceTextField: UITextField!
    @IBOutlet weak var vocabDefinitionTextField: UITextField!
    @IBOutlet weak var pronounciationTextField: UITextField!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!

    @IBAction func playVocabPronounciation(_ sender: UIButton) {
        viewModel?.playVocabPronounciation()
    }
    
    @IBAction func navigateToPreviousVocab(_ sender: UIButton) {
        viewModel?.navigatePrev()
    }
    
    @IBAction func navigateToNextVocab(_ sender: UIButton) {
        viewModel?.navigateNext()
    }
    
    var viewModel: LessonVocabViewModel? {
        didSet {
            fillUI()
        }
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
        
        viewModel.currVocab.bindAndFire { [unowned self] in self.vocabTextField.text = $0 }
        viewModel.currSentenceDefinition.bindAndFire { [unowned self] in self.sentenceDefinitionTextField.text = $0 }
        viewModel.currSentence.bindAndFire { [unowned self] in self.sentenceTextField.text = $0 }
        viewModel.currVocabDefinition.bindAndFire { [unowned self] in self.vocabDefinitionTextField.text = $0 }
        viewModel.currVocabPronounciation.bindAndFire { [unowned self] in self.pronounciationTextField.text = $0 }
        viewModel.isLastVocab.bindAndFire { [unowned self] in self.nextButton.isEnabled = !$0 }
        viewModel.isFirstVocab.bindAndFire { [unowned self] in self.prevButton.isEnabled = !$0 }
    }
}
