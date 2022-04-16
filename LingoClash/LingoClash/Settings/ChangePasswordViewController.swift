//
//  ChangePasswordViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit
import Combine

class ChangePasswordViewController: UIViewController {

    @IBOutlet private var currentPasswordTextField: UITextField!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var confirmNewPasswordTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!

    weak var viewModel: SettingsViewModel?
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpBinders()
    }

    private func setUpView() {
        errorLabel.hide()
    }

    private func setUpBinders() {
        viewModel?.$changePasswordError.sink {[weak self] error in
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

    @IBAction private func saveButtonTapped(_ sender: Any) {
        let currentPassword = FormUtilities.getTrimmedString(textField: currentPasswordTextField)
        let newPassword = FormUtilities.getTrimmedString(textField: newPasswordTextField)
        let confirmNewPassword = FormUtilities.getTrimmedString(textField: confirmNewPasswordTextField)

        let fields = ChangePasswordFields(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword)
        viewModel?.changePassword(fields)
    }

}
