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
    enum Segue {
        static let toDevLoginVC = "toDevLoginVC"
    }
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        
        if !AppConfigs.Debug.enableLogin {
            directToDevLogin()
        }
    }
    
    func directToDevLogin() {
        performSegue(withIdentifier: Segue.toDevLoginVC, sender: self)
    }
    
    func setUpView() {
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

