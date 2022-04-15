//
//  PKGameMatchFinder.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//
import PromiseKit

protocol PKGameMatchFinder {
    func findGame(playerProfile: Profile) -> Promise<PKGame>
    func cancel(playerProfile: Profile)
}
