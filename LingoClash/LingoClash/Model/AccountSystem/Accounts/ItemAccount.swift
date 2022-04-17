//
//  ItemAccount.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 3/4/22.
//

class ItemAccount<T: Item>: Account {
    let id: Identifier
    var items: [T]
    let owner: AccountOwner
    var transactions = [ItemTransaction<T>]()

    init(id: Identifier, owner: AccountOwner, items: [T]) {
        self.id = id
        self.owner = owner
        self.items = items
    }

    func createTransaction(items: [T], debitOrCredit: DebitOrCredit, description: String) -> ItemTransaction<T>? {
        guard !items.isEmpty else {
            return nil
        }

        let transaction = ItemTransaction<T>(id: "", debitOrCredit: debitOrCredit, items: items, account: self)
        return transaction
    }

    func addTransaction(_ transaction: ItemTransaction<T>) {
        self.transactions.append(transaction)
    }
}
