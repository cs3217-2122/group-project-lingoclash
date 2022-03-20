//
//  Transaction.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class Transaction {
    let debitOrCredit: DebitOrCredit
    let amount: Int
    let account: Account
    let createdAt: Date
    let description: String
    init(debitOrCredit: DebitOrCredit, amount: Int, account: Account, createdAt: Date, description: String = "") {
        self.debitOrCredit = debitOrCredit
        self.amount = amount
        self.account = account
        self.createdAt = createdAt
        self.description = description
    }
}

enum DebitOrCredit {
    case debit
    case credit
}
