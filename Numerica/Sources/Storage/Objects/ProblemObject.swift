//
//  Problem.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 11.09.2024.
//

import Foundation
import SwiftData

@Model
final class ProblemObject {

    var id = UUID()

    var problem: String
    var solution: Int
    var solved: Bool

    init(
        problem: String,
        solution: Int,
        solved: Bool = false
    ) {
        self.problem = problem
        self.solution = solution
        self.solved = solved
    }
}

extension ProblemObject: PersistentObject {

    func convertToModel() -> ProblemModel {
        ProblemModel(
            problem: problem,
            solution: solution,
            solved: solved
        )
    }
}
