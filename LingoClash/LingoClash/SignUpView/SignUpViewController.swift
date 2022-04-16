//
//  SignUpViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmPasswordTextField: UITextField!
    @IBOutlet private var signUpButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!

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

    @IBAction private func signUpTapped(_ sender: Any) {
        let name = FormUtilities.getTrimmedString(textField: nameTextField)
        let email = FormUtilities.getTrimmedString(textField: emailTextField)
        let password = FormUtilities.getTrimmedString(textField: passwordTextField)
        let confirmPassword = FormUtilities.getTrimmedString(textField: confirmPasswordTextField)

        let fields = SignUpFields(name: name, email: email, password: password, confirmPassword: confirmPassword)
        viewModel.signUp(fields)

    }

    @IBAction private func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func transitionToHome() {
        let mainViewController = HomeNavigationViewController.instantiateFromAppStoryboard(AppStoryboard.Home)
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }

}
