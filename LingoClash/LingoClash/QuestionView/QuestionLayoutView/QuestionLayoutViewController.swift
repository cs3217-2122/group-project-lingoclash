//
//  QuestionLayoutViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

import UIKit

protocol QuestionLayoutViewController: UIViewController {
    var delegate: QuestionLayoutVCDelegate? { get set }
}

protocol QuestionLayoutVCDelegate {
    func questionViewController(_ : QuestionLayoutViewController, didAnswerCorrectly: Bool)
}
