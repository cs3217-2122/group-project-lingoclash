//
//  MainRewardSystem.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//

class MainRewardSystem {
    private static let lessonQuizRewardSytem: RewardSystem = LessonQuizRewardSystem()
    private static let pkGameRewardSystem: RewardSystem = PKGameRewardSystem()

    private static var rewardSystems: [RewardSystem] {
        [lessonQuizRewardSytem, pkGameRewardSystem]
    }

    static func setUpObservers() {
        for rewardSystem in rewardSystems {
            rewardSystem.setUpObservers()
        }
    }
}
