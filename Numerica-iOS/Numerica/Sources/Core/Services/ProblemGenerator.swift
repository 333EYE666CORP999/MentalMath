import Foundation

// MARK: - ProblemGenerator

@MainActor
protocol ProblemGeneratorInput {

    func getProblem(for selected: Operator) -> ProblemModel
}

@MainActor
final class ProblemGenerator: ProblemGeneratorInput {

    typealias Problem = ProblemModel

    static var rng = SystemRandomNumberGenerator()

    func getProblem(for selected: Operator) -> ProblemModel {
        selected == .division
        ? constructDivisionOperationProblem()
        : constructProblem(for: selected)
    }
}

// MARK: - Expression Solving

private extension ProblemGenerator {

    func solve(
        lhs: Int,
        operation: Operator,
        rhs: Int
    ) -> Int {
        switch operation {
        case .addition:
            lhs + rhs
        case .subtraction:
            lhs - rhs
        case .multiplication:
            lhs * rhs
        case .division:
            lhs / rhs
        }
    }
}

// MARK: - Expression Generation

private extension ProblemGenerator {

    private func constructDivisionOperationProblem() -> ProblemModel {
        let problem = constructProblem(
            for: .multiplication,
            divisionViaMultiplication: true
        )

        // Additional randomization of lhs / rhs
        let randomPositioningNumber = Int.random(
            in: 0...1,
            using: &Self.rng
        )

        return ProblemModel(
            lhs: randomPositioningNumber == 0 ? problem.rhs : problem.lhs,
            operation: problem.`operator`,
            rhs: randomPositioningNumber == 1 ? problem.rhs : problem.lhs,
            solution: problem.solution
        )
    }

    private func constructProblem(
        for operation: Operator,
        divisionViaMultiplication: Bool = false
    ) -> ProblemModel {
        let lhs = getRandomNumber(
            shouldAvoidZero: operation == .division || divisionViaMultiplication
        )
        let rhs = getRandomNumber(
            shouldAvoidZero: operation == .division || divisionViaMultiplication
        )
        return ProblemModel(
            lhs: lhs,
            operation: operation,
            rhs: rhs,
            solution: solve(
                lhs: lhs,
                operation: operation,
                rhs: rhs
            )
        )
    }

    private func getRandomNumber(
        maxDigitsCount: Int = .maxDigitsCount,
        shouldAvoidZero: Bool = false
    ) -> Int {
        // Ensure the maxDigitsCount is at least 1
        guard maxDigitsCount > .zero else {
            assertionFailure("Max digits count must be greater than zero.")
            return Int.random(
                in: 1...2,
                using: &Self.rng
            )
        }

        // Random digit count in range from 1 to maxDigitsCount
        let digitCount = Int.random(
            in: 1...maxDigitsCount,
            using: &Self.rng
        )

        let maxValueExponent = digitCount

        // Decremented by `1` as 10^2 = 100. 100-1 = 99, max 2-digit number
        let maxValue = (
            pow(10.0, Double(maxValueExponent)) - 1
        ).intValue

        var randomNumber = Int.random(
            in: .zero...maxValue,
            using: &Self.rng
        )

        if shouldAvoidZero && randomNumber == .zero {
            randomNumber = Int.random(
                in: 1...maxValue,
                using: &Self.rng
            )
        }

        return randomNumber
    }
}

// MARK: - Constants

private extension Int {

    static let maxDigitsCount: Self = 1
}
