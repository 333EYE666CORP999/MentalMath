//
//  ProblemModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation

final class ProblemModel {

    static var empty = ProblemModel(
        lhs: .zero,
        operation: .random,
        rhs: .zero,
        solution: .zero
    )

    private(set) var lhs: Int
    private(set) var `operator`: Operator
    private(set) var rhs: Int
    private(set) var solution: Int
    var solved: Bool

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

extension ProblemModel: PersistableModel {

    func convertToObject() -> ProblemObject {
        ProblemObject(
            lhs: lhs,
            operation: `operator`,
            rhs: rhs,
            solution: solution,
            solved: solved
        )
    }
}

extension ProblemModel: ProblemStringRepresentable { }
