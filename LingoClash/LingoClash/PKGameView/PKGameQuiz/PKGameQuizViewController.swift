//
//  PKGameQuizViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import UIKit

class PKGameQuizViewController: UIViewController {
    typealias VM = PKGameQuizViewModel
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
    }
    
    func styleUI() {
        
    }
    
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
    }
}
