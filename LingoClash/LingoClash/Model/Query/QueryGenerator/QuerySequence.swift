//
//  QuerySequence.swift
//  LingoClash
//
//  Created by kevin chua on 5/4/22.
//

import Foundation

// Represents a collection of items. You can add things to the collection, pop it, remove items from the collection
protocol QuerySequence {
    // pops an item from the collection and returns it
    var questionsLeft: Int? { get }
    
    mutating func next() -> Query?
    

}
