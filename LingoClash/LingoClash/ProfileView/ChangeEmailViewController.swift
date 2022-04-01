//
//  ChangeEmailViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var newEmailTextField: UITextField!
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newEmail = FormUtilities.getTrimmedString(textField: newEmailTextField)
        
        let fields = ChangeEmailFields(newEmail: newEmail)
        viewModel.changeEmail(fields)
    }

}
