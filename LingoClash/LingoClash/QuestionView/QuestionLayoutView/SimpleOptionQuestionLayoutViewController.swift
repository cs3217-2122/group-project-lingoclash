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
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
    }
}
