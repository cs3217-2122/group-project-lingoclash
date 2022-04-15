//
//  LoginViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!

    private let viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpBinders()
    }

    func setUpView() {
        errorLabel.hide()

        // Style elements
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleFilledButton(loginButton)
    }

    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.errorLabel.show(withText: error)
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }

    @IBAction private func loginTapped(_ sender: Any) {
        let email = FormUtilities.getTrimmedString(textField: emailTextField)
        let password = FormUtilities.getTrimmedString(textField: passwordTextField)

        let fields = LoginFields(email: email, password: password)
        viewModel.login(fields)
    }

    func transitionToHome() {
        let mainViewController = HomeNavigationViewController.instantiateFromAppStoryboard(AppStoryboard.Home)

        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction private func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
