//
//  UserDataManager.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 23/3/22.
//

class UserManager: DataManager<User> {
    
    init() {
        super.init(resource: "users")
    }
}
