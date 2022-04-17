//
//  RewardSystem.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 1/4/22.
//

import PromiseKit

class RewardSystem: NotificationObserver {
    func setUpObservers() {}

    func getStarReward(amount: Int, description: TransactionDescription)
    -> Promise<CurrencyTransaction<Star>> {
        guard amount > 0 else {
            return Promise.reject(reason: RewardSystemError.invalidRewardAmount)
        }

        return firstly {
            StarAccountManager().getStarAccount()
        }.map { currencyAccount -> CurrencyTransaction<Star>  in
            let transaction = CurrencyTransaction<Star>(id: "-1",
                                                        debitOrCredit: .debit,
                                                        amount: amount,
                                                        account: currencyAccount,
                                                        description: .lessonCompletion)
            return transaction
        }
    }

    func presentReward(transaction: CurrencyTransaction<Star>) {
        transaction.execute()

        StarAccountManager()
            .updateStarAccount(account: transaction.account, newTransaction: transaction)
        .catch { error in
            print(error)
        }
    }
}

protocol RewardSystemView {
    func setUp()
}
