//
//  Answerable.swift
//  LingoClash
//
//  Created by kevin chua on 3/4/22.
//

import Foundation

// Questions are Answerable
protocol Answerable {
    func isCorrect(response: Any) -> Bool
}
