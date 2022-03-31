//
//  SplashViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 6/3/22.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        Logger.info("Starting LingoClash")
        
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        // Style elements
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

