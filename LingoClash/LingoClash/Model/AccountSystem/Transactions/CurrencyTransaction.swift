//
//  CurrencyTransaction.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 3/4/22.
//

import Foundation

class CurrencyTransaction<T: Currency>: Transaction {
    let id: Identifier
    let debitOrCredit: DebitOrCredit
    let amount: Int
    let account: CurrencyAccount<T>
    let createdAt: Date
    let description: TransactionDescription

    init(id: Identifier, debitOrCredit: DebitOrCredit, amount: Int, account: CurrencyAccount<T>,
         description: TransactionDescription, createdAt: Date = Date()) {
        self.id = id
        self.debitOrCredit = debitOrCredit
        self.amount = amount
        self.account = account
        self.createdAt = createdAt
        self.description = description
    }

    func execute() {
        if debitOrCredit == .debit {
            account.balance += amount

        } else {
            if account.balance - amount < 0 {
                return
            }
            account.balance -= amount
        }
        account.addTransaction(self)
    }
}
