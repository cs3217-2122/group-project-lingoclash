//
//  SignUpViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Style elements
        ViewUtilities.styleTextField(firstNameTextField)
        ViewUtilities.styleTextField(lastNameTextField)
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let firstName = Utilities.getTrimmedString(textField: firstNameTextField)
        let lastName = Utilities.getTrimmedString(textField: lastNameTextField)
        let email = Utilities.getTrimmedString(textField: emailTextField)
        let password = Utilities.getTrimmedString(textField: passwordTextField)
        let fields = [firstName, lastName, email, password]
        
        // Validate fields
        let error = validateFields(fields)
        if let error = error {
            showError(error)
            return
        }
        
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.showError("Error creating user.")
            } else {
                guard let result = result else {
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid":result.user.uid]) { error in
                    if error != nil {
                        self.showError("Error saving user data.")
                    }
                }
                
                // Transition to home screen
                self.transitionToHome()
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    ///  Returns: nil if fields are correct, else return error message
    func validateFields(_ fields: [String]) -> String? {
        // Check that all fields are filled in
        if fields.contains("") {
            return "Please fill in all fields."
        }
        
        // Check that email format is valid
        let email = Utilities.getTrimmedString(textField: emailTextField)
        if Utilities.isEmailValid(email) == false {
            return "Please input a valid email."
        }
        
        // Check that password is secure
        let password = Utilities.getTrimmedString(textField: passwordTextField)
        if Utilities.isPasswordValid(password) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }

}
