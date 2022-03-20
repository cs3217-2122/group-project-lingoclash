//
//  Array+subscript.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

extension Array {
    /// Picks `n` random elements (partial Fisher-Yates shuffle approach)
    /// Credit: https://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift
    func getRandomElements(randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}
