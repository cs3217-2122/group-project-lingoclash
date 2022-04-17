//
//  CurrencyAccount.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 3/4/22.
//

class CurrencyAccount<T: Currency>: Account {
    let id: Identifier
    var balance: Int
    let owner: AccountOwner
    var transactions: [CurrencyTransaction<T>]

    init(id: Identifier, owner: AccountOwner, balance: Int, transactions: [CurrencyTransaction<T>] = []) {
        self.id = id
        self.owner = owner
        self.balance = balance
        self.transactions = transactions
    }

    func createTransaction(amount: Int, description: TransactionDescription) -> CurrencyTransaction<T>? {
        guard amount != 0 else {
            return nil
        }
        let action: DebitOrCredit = amount > 0 ? .debit : .credit
        let transaction = CurrencyTransaction<T>(id: "", debitOrCredit: action, amount: abs(amount),
                                                 account: self, description: description)
        return transaction
    }

    func addTransaction(_ transaction: CurrencyTransaction<T>) {
        self.transactions.append(transaction)
    }
}
