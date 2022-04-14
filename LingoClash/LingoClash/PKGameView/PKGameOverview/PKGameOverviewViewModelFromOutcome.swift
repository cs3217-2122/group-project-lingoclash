//
//  PKGameOverviewViewModelFromOutcome.swift
//  LingoClash
//
//  Created by Sherwin Poh on 4/4/22.
//

class PKGameOverviewViewModelFromOutcome: PKGameOverviewViewModel {
    var titleOutcome: String
    var descriptionOutcome: String
    var isBackgroundDark: Bool
    private let playerOutcome: PKGamePlayerOutcome
    private let profileScores: [(profile: Profile, score: Int)]
    var scores: [String]
    var names: [String]
    init(outcome: PKGameOutcome, currentPlayer: Profile) {
        let profileScoresUnsorted = outcome.scores.map { (profile: $0, score: $1) }
        self.profileScores = profileScoresUnsorted.filter({ $0.profile == currentPlayer }) + profileScoresUnsorted.filter({ $0.profile != currentPlayer })

        self.names = profileScores.map { $0.profile.name }
        self.scores = profileScores.map { String($0.score) }
        
        guard let playerOutcome = outcome.playerOutcomes[currentPlayer] else {
            fatalError("Unable to get current player outcome")
        }
        self.playerOutcome = playerOutcome
        
        switch playerOutcome {
        case .lose:
            self.titleOutcome = "Loss"
            self.descriptionOutcome = "Better luck next time."
            self.isBackgroundDark = true
        case .win:
            self.titleOutcome = "Victorious"
            self.descriptionOutcome = "Masterful!"
            self.isBackgroundDark = false
        case .draw:
            self.titleOutcome = "Draw"
            self.descriptionOutcome = "You have met your match."
            self.isBackgroundDark = true
        }
    }
}
