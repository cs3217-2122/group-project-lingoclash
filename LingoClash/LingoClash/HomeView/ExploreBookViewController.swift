//
//  ExploreBookViewController.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 8/4/22.
//

import UIKit

class ExploreBookViewController: UIViewController {

    @IBOutlet private var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    func setUpView() {
        ViewUtilities.styleCard(containerView)
    }
}
