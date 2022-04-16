//
//  EditProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var starsGoalTextField: UITextField!
    @IBOutlet private var bioTextField: UITextField!
    @IBOutlet private var errorLabel: UILabel!

    weak var viewModel: SettingsViewModel?
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
        viewModel?.$name.sink {[weak self] name in
            if let name = name {
                self?.nameTextField.text = name
            }
        }.store(in: &cancellables)

        viewModel?.$starsGoal.sink {[weak self] starsGoal in
            if let starsGoal = starsGoal {
                self?.starsGoalTextField.text = "\(starsGoal)"
            }
        }.store(in: &cancellables)

        viewModel?.$bio.sink {[weak self] bio in
            if let bio = bio {
                self?.bioTextField.text = bio
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
                self?.showDoneAlert(content: alertContent) { _ in
                    self?.dismiss(animated: true)
                }
            }
        }.store(in: &cancellables)
    }

    @IBAction private func saveButtonTapped(_ sender: Any) {
        let name = FormUtilities.getTrimmedString(textField: nameTextField)
        let bio = FormUtilities.getTrimmedString(textField: bioTextField)
        let starsGoal = FormUtilities.getTrimmedString(textField: starsGoalTextField)

        let fields = EditProfileFields(
            name: name,
            starsGoal: Int(starsGoal) ?? 0,
            bio: bio)
        viewModel?.editProfile(fields)
    }

}
