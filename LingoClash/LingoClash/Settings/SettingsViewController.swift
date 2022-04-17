//
//  SettingsViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 12/4/22.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {

    private let viewModel = SettingsViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.refresh()
        applyTheme()
        setUpBinders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRefresh()
    }

    @IBAction private func themeChanged(_ sender: UISwitch) {
        Theme.current = sender.isOn ? LightTheme() : DarkTheme()
        UserDefaults.standard.set(sender.isOn, forKey: "LightTheme")
        applyTheme()
    }
    
    @IBAction private func logoutTapped(_ sender: Any) {
        viewModel.signOut()
    }

    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }.store(in: &cancellables)

        viewModel.$alertContent.sink {[weak self] alertContent in
            if let alertContent = alertContent {
                self?.showConfirmAlert(content: alertContent) { _ in
                    self?.transitionToSplash()
                }
            }
        }.store(in: &cancellables)
    }

    func transitionToSplash() {
        let splashViewController = SplashViewController.instantiateFromAppStoryboard(AppStoryboard.Main)

        view.window?.rootViewController = splashViewController
        view.window?.makeKeyAndVisible()
    }

    func showError(_ message: String) {
        Logger.error("Unable to sign out. Error: \(message)")
    }

    private func applyTheme() {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC = segue.destination as? EditProfileViewController {
            editProfileVC.viewModel = self.viewModel
        } else if let changePasswordVC = segue.destination as? ChangePasswordViewController {
            changePasswordVC.viewModel = self.viewModel
        } else if let changeEmailVC = segue.destination as? ChangeEmailViewController {
            changeEmailVC.viewModel = self.viewModel
        }
    }

}
