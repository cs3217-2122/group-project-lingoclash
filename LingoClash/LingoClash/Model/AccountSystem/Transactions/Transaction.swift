//
//  Transaction.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

protocol Transaction {
    var id: Identifier { get }
    var debitOrCredit: DebitOrCredit { get }
    var createdAt: Date { get }
    var description: TransactionDescription { get }
    func execute()
}
