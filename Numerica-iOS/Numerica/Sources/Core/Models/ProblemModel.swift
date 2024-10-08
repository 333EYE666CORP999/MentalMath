import Foundation

// TODO: - поднять в кодстайл - протоколы, полностью с дефолтн реализ - сразу в объявление
struct ProblemModel {

    @MainActor static let empty = Self(
        lhs: .zero,
        operation: .random,
        rhs: .zero,
        solution: .zero
    )

    let lhs: Int
    let `operator`: Operator
    let rhs: Int
    let solution: Int

    var solved = false

    var problemString: String {
        [
            lhs.stringValue,
            `operator`.rawValue,
            rhs.stringValue
        ].joined(separator: " ")
    }

    init(
        lhs: Int,
        operation: Operator,
        rhs: Int,
        solution: Int
    ) {
        self.lhs = lhs
        self.`operator` = operation
        self.rhs = rhs
        self.solution = solution
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

    nonisolated
    var id: UUID {
        UUID()
    }
}
