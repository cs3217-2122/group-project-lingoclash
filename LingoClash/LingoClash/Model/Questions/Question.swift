//
//  Question.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

protocol Question: Query, Answerable {
    static var vocabsTestedCount: Int { get }
    var vocabsTested: Set<Vocab> { get }
    
    var answerToString: String { get }
    
    var context: String { get }
    func isCorrect(response: Any) -> Bool
    func isEqual(to: Question) -> Bool
}
