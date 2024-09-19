//
//  Item.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import Foundation
import SwiftData

@Model
final class GameSessionObject {

    var id = UUID()

    var sessionDate: Date
    var goodAnswersCount: Int
    var badAnswersCount: Int

    var problems: [ProblemObject]

    init(
        sessionDate: Date,
        problems: [ProblemObject],
        goodAnswersCount: Int = .zero,
        badAnswersCount: Int = .zero
    ) {
        self.sessionDate = sessionDate
        self.goodAnswersCount = goodAnswersCount
        self.badAnswersCount = badAnswersCount
        self.problems = problems
    }
}

extension GameSessionObject: PersistentObject {

    func convertToModel() -> GameSessionModel {
        GameSessionModel(
            sessionDate: sessionDate,
            goodAnswersCount: goodAnswersCount,
            badAnswersCount: badAnswersCount,
            problems: problems.map { $0.convertToModel() }
        )
    }
}
