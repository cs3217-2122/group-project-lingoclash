//
//  EditProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var viewModel: ProfileViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpBinders()
        viewModel?.refreshProfile()
    }
    
    func setUpView() {
        errorLabel.hide()
    }
    
    func setUpBinders() {
        viewModel?.$firstName.sink {[weak self] firstName in
            if let firstName = firstName {
                self?.firstNameTextField.text = firstName
            }
        }.store(in: &cancellables)
        
        viewModel?.$lastName.sink {[weak self] lastName in
            if let lastName = lastName {
                self?.lastNameTextField.text = lastName
            }
        }.store(in: &cancellables)
        
        viewModel?.$editProfileError.sink {[weak self] error in
            if let error = error {
                self?.errorLabel.show(withText: error)
            } else {
                self?.errorLabel.hide()
            }
        }.store(in: &cancellables)
        
        viewModel?.$alertContent.sink {[weak self] alertContent in
            if let alertContent = alertContent {
                self?.showDoneAlert(title: alertContent.title, message: alertContent.message) { _ in
                    self?.dismiss(animated: true)
                }
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let firstName = FormUtilities.getTrimmedString(textField: firstNameTextField)
        let lastName = FormUtilities.getTrimmedString(textField: lastNameTextField)
        
        let fields = EditProfileFields(firstName: firstName, lastName: lastName)
        viewModel?.editProfile(fields)
    }
    
}
