//
//  Item.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import Foundation
import SwiftData

@Model
final class GameSession {

    var sessionDate: Date
    var goodAnswersCount: Int
    var badAnswersCount: Int

    @Relationship(deleteRule: .noAction)
    var problems = [Problem]()

    init(
        sessionDate: Date = Date(),
        goodAnswersCount: Int = .zero,
        badAnswersCount: Int = .zero
    ) {
        self.sessionDate = sessionDate
        self.goodAnswersCount = goodAnswersCount
        self.badAnswersCount = badAnswersCount
    }
}

@Model
final class Problem {

    var problem: String
    var solution: Int

    init(problem: String, solution: Int) {
        self.problem = problem
        self.solution = solution
    }
}
