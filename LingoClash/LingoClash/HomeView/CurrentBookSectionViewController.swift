//
//  CurrentBookViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 22/3/22.
//

import UIKit

class CurrentBookSectionViewController: UITabBarController {
    
    private let currentBookViewIndex = 0
    private let noBookViewIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    func setUpView() {
        // TODO: Check if current book present with db
        let currentBookPresent = true
        if currentBookPresent {
            self.selectedIndex = currentBookViewIndex
        } else {
            self.selectedIndex = noBookViewIndex
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }

}
