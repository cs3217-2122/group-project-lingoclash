//
//  StarView.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

import UIKit

class StarView: UIImageView {
    var isFilled = false {
        didSet {
            refreshView()
        }
    }

    func refreshView() {
        if isFilled {
            image = #imageLiteral(resourceName: "star")
        } else {
            image = #imageLiteral(resourceName: "star_grey")
        }
    }
}
