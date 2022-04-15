//
//  CurrencySystem.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//
import Foundation

class CurrencySystem {
    func performTransaction(amount: Int, account: Account, description: String) {
        guard amount != 0 else {
            return
        }
        let action = amount > 0 ? DebitOrCredit.credit : DebitOrCredit.debit
        let currentDateAndTime = Date()
        let transaction = Transaction(
            debitOrCredit: action,
            amount: amount,
            account: account,
            createdAt: currentDateAndTime)
        account.transactions.append(transaction)
        // TODO: Update the database (add transaction )
    }
}
