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
        
        signUpButton.isEnabled = false
        loginButton.isEnabled = false
        
        firstly {
            setUpData()
        }.done {
            self.setUpView()
        }.catch { error in
            Logger.error("Failed to create some sample data: \(error)")
        }
    }
    
    private func setUpData() -> Promise<Void> {
        Logger.info("Initializing LingoClash")
        
        #if DEVELOPMENT
        Logger.info("Development environment detected. Will be starting with sample data")
        return SampleDataUtilities.createSampleData()
        #else
        return Promise.resolve(value: ())
        #endif
    }
    
    func setUpView() {
        // Style elements
        // TODO: perhaps programmatically create the buttons, so don't need to do this trick
        signUpButton.isEnabled = true
        loginButton.isEnabled = true
        signUpButton.alpha = 1
        loginButton.alpha = 1
        
        ViewUtilities.styleFilledButton(signUpButton)
        ViewUtilities.styleHollowButton(loginButton)
    }
}

