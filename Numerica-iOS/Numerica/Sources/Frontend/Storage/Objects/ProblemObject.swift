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

    private(set) var lhs: Int
    private(set) var `operator`: Operator
    private(set) var rhs: Int
    private(set) var solution: Int
    private(set) var solved: Bool

    init(
        lhs: Int,
        operation: Operator,
        rhs: Int,
        solution: Int,
        solved: Bool = false
    ) {
        self.lhs = lhs
        self.`operator` = operation
        self.rhs = rhs
        self.solution = solution
        self.solved = solved
    }
}

extension ProblemObject: PersistentObject {

    func convertToModel() -> ProblemModel {
        ProblemModel(
            lhs: lhs,
            operation: `operator`,
            rhs: rhs,
            solution: solution
        )
    }
}
