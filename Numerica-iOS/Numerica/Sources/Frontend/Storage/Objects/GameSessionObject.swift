import Foundation
import SwiftData

@Model
@preconcurrency
final class GameSessionObject {

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
