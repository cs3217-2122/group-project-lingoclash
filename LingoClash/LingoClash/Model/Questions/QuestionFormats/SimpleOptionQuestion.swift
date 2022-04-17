//
//  SimpleOptionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

/// Unfortunately swift's limitation of not being able to have generic type protocols that can act as assignable types,
/// limits the generalisability of the protocol
protocol SimpleOptionQuestion: Question {
    var options: [String] { get }
    var answer: String { get }
}
