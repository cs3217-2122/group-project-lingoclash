//
//  Account.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

protocol Account {
    var id: Identifier { get }
    var owner: AccountOwner { get }
}
