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
        super.viewDidLoad()
        
        setUpData()
        setUpView()
        
    }
    
    private func setUpData() {
        Logger.info("Initializing LingoClash")
        
        #if DEVELOPMENT
        Logger.info("Development environment detected. Will be starting with sample data")
        SampleDataUtilities.createSampleData()
        #endif
    }
    
    func setUpView() {
        // Style elements
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

