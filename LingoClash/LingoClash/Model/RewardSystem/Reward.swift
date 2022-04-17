//
//  Reward.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 4/4/22.
//

class Reward {
    let transactions: [Transaction]

    init(transactions: [Transaction]) {
        self.transactions = transactions
    }

    func presentReward() {
        for transaction in transactions {
            transaction.execute()
        }
    }
}
