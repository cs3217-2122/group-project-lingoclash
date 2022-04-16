//
//  PKGameOverviewViewModel.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

protocol PKGameOverviewViewModel {
    var scores: [String] { get }
    var names: [String] { get }
    var titleOutcome: String { get }
    var descriptionOutcome: String { get }
    var isBackgroundDark: Bool { get }
}
