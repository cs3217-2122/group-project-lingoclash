//
//  ChangeEmailViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var confirmNewEmailTextField: UITextField!
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newEmail = Utilities.getTrimmedString(textField: newEmailTextField)
        let confirmNewEmail = Utilities.getTrimmedString(textField: confirmNewEmailTextField)
        
        viewModel.changeEmail(newEmail: newEmail, confirmNewEmail: confirmNewEmail)
    }

}
