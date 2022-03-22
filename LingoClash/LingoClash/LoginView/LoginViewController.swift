//
//  LoginViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import Combine

import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel = LoginViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpBinders()
        
        // TODO: To be removed
        let bookDataManager = BookDataManager()
        let books = bookDataManager.getList()
        
        try? Auth.auth().signOut()
        print("current user:", Auth.auth().currentUser ?? "")
        
        books.done { books in
            print("Books fetched: ", books)
        }.catch { error in
            print("Error: ", error)
        }
    }
    
    func setUpView() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Style elements
        ViewUtilities.styleTextField(emailTextField)
        ViewUtilities.styleTextField(passwordTextField)
        ViewUtilities.styleFilledButton(loginButton)
    }
    
    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                self?.showError(error)
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = Utilities.getTrimmedString(textField: emailTextField)
        let password = Utilities.getTrimmedString(textField: passwordTextField)
        
        viewModel.login(email: email, password: password)
        
    }
    
    func transitionToHome() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: AppConfigs.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func backTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
