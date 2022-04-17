//
//  StarTransactionData.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 13/4/22.
//

import Foundation

struct StarTransactionData {
    var id: Identifier
    let account_id: Identifier
    let amount: Int
    let createdAt: Date
    let debitOrCredit: DebitOrCredit
    let description: TransactionDescription
}

extension StarTransactionData: Record {}
