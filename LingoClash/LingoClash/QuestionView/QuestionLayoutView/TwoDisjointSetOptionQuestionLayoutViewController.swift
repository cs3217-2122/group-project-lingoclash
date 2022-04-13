//
//  twoDisjointSetOptionQuestionLayoutViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import UIKit

class TwoDisjointSetOptionQuestionLayoutViewController: UIViewController, QuestionLayoutViewController {
    typealias VM = TwoDisjointSetOptionQuestionLayoutViewModel

    var delegate: QuestionLayoutVCDelegate?
    
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
    }
    
    // TODO: perhaps remove this since it is not used.
    func styleUI() {
        
    }
    
    // TODO: perhaps remove this since it is not used.
    func fillUI() {
//        guard isViewLoaded, let viewModel = viewModel else {
//            return
//        }
    }
}
