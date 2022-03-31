//
//  ChangeEmailViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit
import Combine

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var viewModel: ProfileViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpBinders()
    }
    
    func setUpView() {
        errorLabel.hide()
    }
    
    func setUpBinders() {
        viewModel?.$changeEmailError.sink {[weak self] error in
            if let error = error {
                self?.errorLabel.show(withText: error)
            } else {
                self?.errorLabel.hide()
            }
        }.store(in: &cancellables)
        
        viewModel?.$alertContent.sink {[weak self] alertContent in
            if let alertContent = alertContent {
                self?.showDoneAlert(content: alertContent) { _ in
                    self?.dismiss(animated: true)
                }
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newEmail = FormUtilities.getTrimmedString(textField: newEmailTextField)
        
        let fields = ChangeEmailFields(newEmail: newEmail)
        viewModel?.changeEmail(fields)
    }

}
