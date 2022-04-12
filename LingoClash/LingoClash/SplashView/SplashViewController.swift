//
//  SplashViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 6/3/22.
//

import UIKit
import PromiseKit
import Combine


class SplashViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        setUpBinders()
        
        if !AppConfigs.Debug.enableLogin {
            directLogin()
        }
    }
    
    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                Logger.error("Fail to bypass login. Error: \(error)")
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }
    
    private func directLogin() {
        #if DEBUG
        Logger.info("DEBUG mode ON. Bypassing login now...")
        Logger.info("You may disable bypassing in AppConfigs")
        let email = AppConfigs.Debug.testEmail
        let password = AppConfigs.Debug.testPassword
        
        let fields = LoginFields(email: email, password: password)
        viewModel.login(fields)
        #endif
    }
    
    func transitionToHome() {
        let mainViewController = HomeNavigationViewController.instantiateFromAppStoryboard(AppStoryboard.Home)
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    func setUpView() {
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

