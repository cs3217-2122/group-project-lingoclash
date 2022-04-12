//
//  SettingsViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 12/4/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func themeChanged(_ sender: UISwitch) {
        if sender.isOn {
            Theme.current = LightTheme()
        } else {
            Theme.current = SpaceTheme()
        }
        
        applyTheme()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func applyTheme() {
        view.backgroundColor = Theme.current.primary
    }
    
}
