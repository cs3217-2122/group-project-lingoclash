//
//  SettingsViewController.swift
//  LingoClash
//
//  Created by Kyle キラ on 12/4/22.
//

import UIKit


class SettingsViewController: UIViewController {
    
    @IBAction func themeChanged(_ sender: UISwitch) {
        Theme.current = sender.isOn ? LightTheme() : DarkTheme()
        UserDefaults.standard.set(sender.isOn, forKey: "LightTheme")
        applyTheme()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
    }
    
    fileprivate func applyTheme() {
        //        view.backgroundColor = Theme.current.primary
    }
    
}
