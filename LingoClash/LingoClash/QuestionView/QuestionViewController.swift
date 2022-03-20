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
        
        viewModel.questionLayoutViewModel?.bindAndFire { [unowned self] in loadQuestionLayoutViewController(belongingTo: $0)}
        
    }
    
    private func loadQuestionLayoutViewController(belongingTo questionLayoutViewModel: QuestionLayoutViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        var viewController: QuestionLayoutViewController?
        switch questionLayoutViewModel {
        case let simpleOptionQuestionLayoutViewModel as SimpleOptionQuestionLayoutViewModel:
            viewController = storyboard.instantiateViewController(identifier: SimpleOptionQuestionLayoutViewController.identifier)
                                                as? SimpleOptionQuestionLayoutViewController
        case let twoDisjointSetOptionQuestionLayoutViewModel as TwoDisjointSetOptionQuestionLayoutViewModel:
            viewController = storyboard.instantiateViewController(identifier: TwoDisjointSetOptionQuestionLayoutViewController.identifier)
                                                as? TwoDisjointSetOptionQuestionLayoutViewController
        default:
            return
        }
        if let viewController = viewController {
            viewController.delegate = self
            loadQuestionLayoutViewController(viewController)
        }
    }
    
    private func loadQuestionLayoutViewController(_ viewController: QuestionLayoutViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        setVCConstraints(viewController)
        viewController.didMove(toParent: self)
    }
    
    private func setVCConstraints(_ viewController: QuestionLayoutViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setUpViewModel() {
        guard let vm = datasource?.setViewModel(self) else {
            return
        }
        self.viewModel = vm
    }
}

extension QuestionViewController: QuestionLayoutVCDelegate {
    func questionViewController(_: QuestionLayoutViewController, didAnswerCorrectly: Bool) {
        self.delegate?.questionViewController(self, didAnswerCorrectly: didAnswerCorrectly)
    }
}

protocol QuestionViewControllerDataSource {
    func setViewModel(_: QuestionViewController) -> QuestionViewModel?
}

protocol QuestionViewControllerDelegate {
    func questionViewController(_ : QuestionViewController, didAnswerCorrectly: Bool)
}
