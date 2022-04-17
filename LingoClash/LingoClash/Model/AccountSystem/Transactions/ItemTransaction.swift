//
//  ItemTransaction.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 3/4/22.
//

import Foundation

class ItemTransaction<T: Item>: Transaction {
    let id: Identifier
    let debitOrCredit: DebitOrCredit
    let items: [T]
    let account: ItemAccount<T>
    let createdAt: Date
    let description: String

    init(id: Identifier, debitOrCredit: DebitOrCredit, items: [T], account: ItemAccount<T>, createdAt: Date = Date(), description: String = "") {
        self.id = id
        self.debitOrCredit = debitOrCredit
        self.items = items
        self.account = account
        self.createdAt = createdAt
        self.description = description
    }

    func execute() {
//        if debitOrCredit == .debit {
//            var indices = [Int]()
//            for item in items {
//                if let index = self.items.firstIndex(of: item) {
//                    indices.append(index)
//                } else {
//                    return
//                }
//            }
//
//            for index in indices {
//                self.items.remove(at: index)
//            }
//        } else {
//            self.items += items
//        }
//        account.addTransaction(self)

        // TODO: Save to db
    }
}
