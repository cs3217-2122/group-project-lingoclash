//
//  ChangePasswordViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let currentPassword = Utilities.getTrimmedString(textField: currentPasswordTextField)
        let newPassword = Utilities.getTrimmedString(textField: newPasswordTextField)
        let confirmNewPassword = Utilities.getTrimmedString(textField: confirmNewPasswordTextField)
        
        viewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword)
    }
    
}
