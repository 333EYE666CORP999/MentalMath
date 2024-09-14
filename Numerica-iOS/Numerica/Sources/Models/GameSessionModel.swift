//
//  GameSessionModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation

final class GameSessionModel {

    var sessionDate: Date
    var goodAnswersCount: Int
    var badAnswersCount: Int
    var problems: [ProblemModel]

    init(
        sessionDate: Date,
        goodAnswersCount: Int = .zero,
        badAnswersCount: Int = .zero,
        problems: [ProblemModel] = [ProblemModel]()
    ) {
        self.sessionDate = sessionDate
        self.goodAnswersCount = goodAnswersCount
        self.badAnswersCount = badAnswersCount
        self.problems = problems
    }
}

extension GameSessionModel: PersistableModel {

    func convertToObject() -> GameSessionObject {
        GameSessionObject(
            sessionDate: sessionDate,
            problems: problems.map { $0.convertToObject() },
            goodAnswersCount: goodAnswersCount,
            badAnswersCount: badAnswersCount
        )
    }
}
