//
//  QuestionViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import UIKit

class QuestionViewController: UIViewController {
    typealias VM = QuestionViewModel
    var datasource: QuestionViewControllerDataSource?
    var delegate: QuestionViewControllerDelegate?
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        styleUI()
        fillUI()
    }
    
    func reloadData() {
        setUpViewModel()
    }
    
    private func styleUI() {
        
    }
    
    private func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        
    }
    
    private func setUpViewModel() {
        guard let vm = datasource?.setViewModel(self) else {
            return
        }
        self.viewModel = vm
    }
}

protocol QuestionViewControllerDataSource {
    func setViewModel(_: QuestionViewController) -> QuestionViewModel?
}

protocol QuestionViewControllerDelegate {
    func questionViewController(_ : QuestionViewController, didAnswerCorrectly: Bool)
}
