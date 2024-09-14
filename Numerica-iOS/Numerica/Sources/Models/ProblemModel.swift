//
//  ProblemModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation

final class ProblemModel {

    var problem: String
    var solution: Int
    var solved: Bool

    init(
        problem: String,
        solution: Int,
        solved: Bool
    ) {
        self.problem = problem
        self.solution = solution
        self.solved = solved
    }
}

extension ProblemModel: PersistableModel {

    func convertToObject() -> ProblemObject {
        ProblemObject(
            problem: problem,
            solution: solution,
            solved: solved
        )
    }
}
