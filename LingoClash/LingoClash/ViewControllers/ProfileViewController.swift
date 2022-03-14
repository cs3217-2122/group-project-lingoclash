//
//  ProfileViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/3/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            showLogOutPopUp()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func transitionToSplash() {
        let splashViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.splashVC) as? SplashViewController
        
        view.window?.rootViewController = splashViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showLogOutPopUp() {
        let title = ""
        let message = "Are you sure you want to log out?"
        let alert = Utilities.createAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            self.transitionToSplash()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
