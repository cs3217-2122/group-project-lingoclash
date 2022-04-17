//
//  PKGameRewardSystem.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//

import Foundation

class PKGameRewardSystem: RewardSystem {
    override func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(pkGameWon(_:)), name: .PKGameWon, object: nil)
    }

    @objc func pkGameWon(_ notification: Notification) {
        // TODO: add stars for user
    }
}
