//
//  LoginViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Style elements
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = Utilities.getTrimmedString(textField: emailTextField)
        let password = Utilities.getTrimmedString(textField: passwordTextField)
        let fields = [email, password]
        
        // Validate fields
        let error = validateFields(fields)
        if let error = error {
            showError(error)
            return
        }
        
        // Sign in
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.showError("Incorrect email or password.")
            } else {
                self.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    ///  Returns: nil if fields are correct, else return error message
    func validateFields(_ fields: [String]) -> String? {
        // Check that all fields are filled in
        if fields.contains("") {
            return "Please fill in all fields."
        }
        
        return nil
    }

    @IBAction func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
