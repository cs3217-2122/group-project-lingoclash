//
//  LessonQuizRewardSystem.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//

import Foundation
import PromiseKit
import UIKit

class LessonQuizRewardSystem: RewardSystem {
    override func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(lessonQuizPassed(_:)), name: .lessonQuizPassed, object: nil)
    }

    @objc func lessonQuizPassed(_ notification: Notification) {
        guard let dict = notification.userInfo, let star_count = dict["stars"] as? Int else {
            return
        }

        // TODO: Check number of stars before assigning
        firstly {
            StarAccountManager().getStarAccount()
        }.done { currencyAccount in
            let transaction = CurrencyTransaction<Star>(id: "-1", debitOrCredit: .debit, amount: star_count, account: currencyAccount)
            let reward = Reward(transactions: [transaction])

            reward.presentReward()
            StarAccountManager().updateStarAccount(account: currencyAccount, newTransaction: transaction).catch { error in
                print(error)
            }

            SnackbarUtilities.showSnackbar(type: .info, text: "You earned \(star_count) stars!")
        }.catch { error in
            print(error)
        }
    }
}
