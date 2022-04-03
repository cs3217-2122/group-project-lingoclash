//
//  SplashViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 6/3/22.
//

import UIKit
import PromiseKit


class SplashViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    func setUpView() {
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

