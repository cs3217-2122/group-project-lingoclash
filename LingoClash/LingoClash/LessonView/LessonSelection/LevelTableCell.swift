//
//  LessonTableCell.swift
//  LingoClash
//
//  Created by Sherwin Poh on 23/3/22.
//

import UIKit

class LessonTableCell: UITableViewCell {
    typealias VM = LessonTableCellViewModel
    var viewModel: VM? {
        didSet {
            fillUI()
        }
    }
    func fillUI() {
        guard isViewLoaded, let viewModel = viewModel else {
            return
        }
        viewModel.starsFilled.enumerated().forEach { stars[$0.offset].isFilled = $0.element }
        self.levelName.text = viewModel.lessonName
    }
    static let reuseIdentifier = "levelTableCell"
    var levelName: String = "" {
        didSet {
            self.levelNameLabel.text = levelName
        }
    }
    var 
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet var stars: [StarView]!
}
