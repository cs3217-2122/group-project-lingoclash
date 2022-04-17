//
//  OptionTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import UIKit
import PromiseKit

class OptionTableCell: UITableViewCell {
    static let reuseIdentifier = "optionTableCell"
    var optionText: String = "" {
        didSet {
            self.optionLabel.text = optionText
        }
    }

    func animate(isCorrect: Bool, duration: Double) -> Promise<Bool> {
        Promise { seal in
            UIView.animate(withDuration: duration,
                           animations: {
                if isCorrect {
                    self.backgroundColor = Theme.current.green
                    self.optionLabel.textColor = .white
                } else {
                    self.backgroundColor = Theme.current.errorContainer
                    self.optionLabel.textColor = Theme.current.errorText
                }
            }, completion: { _ -> Void in
                seal.fulfill(true)
            })
        }

    }

    @IBOutlet private var optionLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 1.0
    }
}
