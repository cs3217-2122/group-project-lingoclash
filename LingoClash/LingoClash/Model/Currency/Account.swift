//
//  File.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

class Account {
    let total: Int
    var transactions = [Transaction]()
    init(total: Int) {
        self.total = total
    }

    func addTransaction(_ transaction: Transaction) {
        self.transactions.append(transaction)
    }
}
