//
//  EditProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let firstName = Utilities.getTrimmedString(textField: firstNameTextField)
        let lastName = Utilities.getTrimmedString(textField: lastNameTextField)
        
        viewModel.editProfile(firstName: firstName, lastName: lastName)
    }
    
}
