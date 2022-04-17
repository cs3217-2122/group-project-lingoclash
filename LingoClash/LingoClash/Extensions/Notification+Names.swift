//
//  Notification+Names.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//
import Foundation

extension Notification.Name {
    static var lessonQuizPassed: Notification.Name {
        .init(rawValue: "LessonQuizCompleted.Pass")
    }

    static var PKGameWon: Notification.Name {
        .init(rawValue: "PKGameCompleted.Won")
    }

    static var PKGameLost: Notification.Name {
        .init(rawValue: "PKGameCompleted.Lost")
    }
}
