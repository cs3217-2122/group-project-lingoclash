//
//  QueueEntry.swift
//  LingoClash
//
//  Created by Sherwin Poh on 3/4/22.
//

import Foundation

struct QueueEntry {
    var id: Identifier
    var playerProfile: ProfileData
    var joinedAt: Date
    var isWaiting: Bool
    var gameType: String
    var gameId: Identifier?
}

extension QueueEntry: Record {}
