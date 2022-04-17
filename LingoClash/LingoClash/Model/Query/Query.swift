//
//  Query.swift
//  LingoClash
//
//  Created by kevin chua on 3/4/22.
//

import Foundation


// A Query is more general than a Question.
// It just has the context (Question to be asked)
// and the answer in string format.
// isCorrect etc is addressed in Answerable.

protocol Query {
    var context: String { get }
    
    var answerToString: String { get }
}
