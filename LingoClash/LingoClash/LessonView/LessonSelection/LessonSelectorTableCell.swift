//
//  LessonSelectorTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

import UIKit

class LessonSelectorTableCell: UITableViewCell {
    typealias VM = LessonTableCellViewModel
    static let reuseIdentifier = "lessonSelectorTableCell"

    @IBOutlet private var levelNameLabel: UILabel!
    @IBOutlet private var stars: [StarView]!

    var levelName: String = "" {
        didSet {
            self.levelNameLabel.text = levelName
        }
    }

    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }

    func fillUI() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.starsFilled.enumerated().forEach { stars[$0.offset].isFilled = $0.element }
        self.levelNameLabel.text = viewModel.lessonName
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
