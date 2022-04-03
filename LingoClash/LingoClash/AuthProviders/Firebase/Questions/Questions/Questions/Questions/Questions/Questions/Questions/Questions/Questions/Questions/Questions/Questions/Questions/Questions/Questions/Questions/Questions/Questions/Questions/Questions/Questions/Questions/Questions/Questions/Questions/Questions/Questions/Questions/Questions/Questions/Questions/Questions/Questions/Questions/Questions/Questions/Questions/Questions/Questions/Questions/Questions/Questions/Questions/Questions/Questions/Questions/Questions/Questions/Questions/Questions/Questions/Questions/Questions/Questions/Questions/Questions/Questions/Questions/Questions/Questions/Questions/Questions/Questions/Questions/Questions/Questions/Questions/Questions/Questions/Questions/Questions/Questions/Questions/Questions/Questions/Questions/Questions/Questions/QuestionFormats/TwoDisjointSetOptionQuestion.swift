//
//  DisjointSetOptionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

protocol TwoDisjointSetOptionQuestion: Question {
    var context: String { get }
    var options: Set<Pair<String>> { get }
    var answer: Set<Pair<String>> { get }
}

struct Pair<T: Codable & Hashable>: Codable, Hashable {
    let first: T
    let second: T
}
