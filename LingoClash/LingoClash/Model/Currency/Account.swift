//
//  File.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class Account {
    let owner: User
    let total: Int
    var transactions = [Transaction]()
    init(owner: User, total: Int) {
        self.owner = owner
        self.total = total
    }

    func addTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
    }
}
