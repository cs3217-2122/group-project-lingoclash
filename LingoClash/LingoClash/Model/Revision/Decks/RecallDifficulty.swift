//
//  RecallDifficulty.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

import Foundation

// A higher integer is positively correlated with the time before seeing it again
// Current formula: difficulty - hours since done
enum RecallDifficulty: Int, CaseIterable, Codable {
  /// The learner was unable to get the answer
  case again = 0

  /// The learner would like to review the content more frequently, can remember with a lot of help
  case hard = 1

  /// The learner could recall the information needed with the expected amount of difficulty
  case good = 2

  /// The learner would not like to see this prompt again (perhaps 4 days later)
  case easy = 3
}
