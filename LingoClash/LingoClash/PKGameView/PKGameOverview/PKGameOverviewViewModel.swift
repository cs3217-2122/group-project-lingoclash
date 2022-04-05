//
//  PKGameOverviewViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

protocol PKGameOverviewViewModel {
    var didWin: Bool { get }
    var scores: [String] { get }
    var names: [String] { get }
}
