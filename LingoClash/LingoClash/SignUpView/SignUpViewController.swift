//
//  SignUpViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel = SignUpViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpBinders()
        
    }
    
    func setUpView() {
        errorLabel.hide()
        
        // Style elements
        ViewUtilities.styleTextField(firstNameTextField)
        ViewUtilities.styleTextField(lastNameTextField)
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleFilledButton(signUpButton)
    }
    
    private func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.errorLabel.show(withText: error)
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let firstName = FormUtilities.getTrimmedString(textField: firstNameTextField)
        let lastName = FormUtilities.getTrimmedString(textField: lastNameTextField)
        let email = FormUtilities.getTrimmedString(textField: emailTextField)
        let password = FormUtilities.getTrimmedString(textField: passwordTextField)
        
        let fields = SignUpFields(firstName: firstName, lastName: lastName, email: email, password: password)
        viewModel.signUp(fields)
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func transitionToHome() {
        let mainViewController = HomeNavigationViewController.instantiateFromAppStoryboard(appStoryboard: AppStoryboard.Home)
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
}
