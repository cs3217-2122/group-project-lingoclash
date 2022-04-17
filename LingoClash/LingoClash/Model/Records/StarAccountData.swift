//
//  StarAccountData.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 12/4/22.
//

struct StarAccountData {
    var id: Identifier
    let owner_id: Identifier
    let balance: Int

    init(id: Identifier, ownerId: Identifier, balance: Int) {
        self.id = id
        self.owner_id = ownerId
        self.balance = balance
    }

    init(ownerId: Identifier) {
        self.init(id: "-1", ownerId: ownerId, balance: 0)
    }
}

extension StarAccountData: Record {}
