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
        // Hide error label
        errorLabel.alpha = 0
        
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
                self?.showError(error)
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let firstName = Utilities.getTrimmedString(textField: firstNameTextField)
        let lastName = Utilities.getTrimmedString(textField: lastNameTextField)
        let email = Utilities.getTrimmedString(textField: emailTextField)
        let password = Utilities.getTrimmedString(textField: passwordTextField)
        
        viewModel.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: AppConfigs.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
}
