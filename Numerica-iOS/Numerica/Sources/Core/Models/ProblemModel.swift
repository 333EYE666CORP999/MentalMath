//
//  ProblemModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation

// TODO: - поднять в кодстайл - протоколы, полностью с дефолтн реализ - сразу в объявление
final class ProblemModel: ProblemStringRepresentable {

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

// TODO: - поднять в кодстайл - протоколы хотя бы без одного дефолта - в экстеншены
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

extension ProblemModel: Identifiable {
    
    var id: UUID {
        UUID()
    }
}
