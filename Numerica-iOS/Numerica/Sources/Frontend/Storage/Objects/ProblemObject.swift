import Foundation
import SwiftData

@Model
final class ProblemObject {

    private var lhs: Int
    private var `operator`: Operator
    private var rhs: Int
    private var solution: Int
    private var solved: Bool

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
