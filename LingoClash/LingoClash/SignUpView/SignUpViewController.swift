//
//  SignUpViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
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
        ViewUtilities.styleTextField(nameTextField)
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleTextField(confirmPasswordTextField)
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
        let name = FormUtilities.getTrimmedString(textField: nameTextField)
        let email = FormUtilities.getTrimmedString(textField: emailTextField)
        let password = FormUtilities.getTrimmedString(textField: passwordTextField)
        let confirmPassword = FormUtilities.getTrimmedString(textField: confirmPasswordTextField)
        
        let fields = SignUpFields(name: name, email: email, password: password, confirmPassword: confirmPassword)
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
