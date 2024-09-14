//
//  File.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation

// MARK: - MathGen

final class ProblemGenerator {

    private var rng = SystemRandomNumberGenerator()

    func getProblem(for selected: Operation? = nil) -> ProblemDTO {
        // FIXME: - какой смысл ей тут появляться опциональной, надо что-то с этим сделать
        let operation: Operation? = if let selected {
            selected
        } else if let randomOperation = Operation.allCases.randomElement(
            using: &rng
        ) {
            randomOperation
        } else {
            nil
        }

        guard let composedOperation = operation else {
            return .empty
        }

        return operation == .division
        ? constructDivisionOperationProblem()
        : constructProblem(for: composedOperation)
    }
}

// MARK: - Expression Solving

private extension ProblemGenerator {

    func solve(expression: String) -> Int {
        let components = expression.split(
            separator: .space
        ).map(
            String.init
        )

        guard
            let lhs = Int(components[.zero]),
            let operation = Operation(rawValue: components[1]),
            let rhs = Int(components[2])
        else {
            return .zero
        }

        return switch operation {
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

    private func constructDivisionOperationProblem() -> ProblemDTO {
        let transformableProblem = constructProblem(
            for: .multiplication,
            divisionViaMultiplication: true
        )
        let components = transformableProblem.problemString.split(
            separator: .space
        )

        // FIXME: - это должно обеспечиваться методом конструкции проблемы
        guard
            let lhs = String(components[0]).intValue,
            let rhs = String(components[2]).intValue
        else {
            return .empty
        }

        // Additional randomization of lhs / rhs
        let randomNumber = Int.random(in: 0...1, using: &rng)

        let divisionProblemString = [
            randomNumber == 0 ? rhs.stringValue : lhs.stringValue,
            Operation.division.rawValue,
            randomNumber == 1 ? rhs.stringValue : lhs.stringValue
        ].joined(separator: .space)

        return ProblemDTO(
            problemString: divisionProblemString,
            solution: solve(expression: divisionProblemString)
        )
    }

    private func constructProblem(
        for operation: Operation,
        divisionViaMultiplication: Bool = false
    ) -> ProblemDTO {
        let problemString = [
            getRandomNumber(
                shouldAvoidZero: operation == .division || divisionViaMultiplication
            ).stringValue,
            operation.rawValue,
            getRandomNumber(
                shouldAvoidZero: operation == .division || divisionViaMultiplication
            ).stringValue
        ].joined(separator: .space)

        return ProblemDTO(
            problemString: problemString,
            solution: solve(expression: problemString)
        )
    }

    private func getRandomNumber(
        maxDigitsCount: Int = .maxDigitsCount,
        shouldAvoidZero: Bool = false
    ) -> Int {
        // Ensure the maxDigitsCount is at least 1
        guard maxDigitsCount > .zero else {
            assertionFailure("Max digits count must be greater than zero.")
            return Int.random(in: 1...2, using: &rng)
        }

        // Random digit count in range from 1 to maxDigitsCount
        let digitCount = Int.random(in: 1...maxDigitsCount, using: &rng)

        let maxValueExponent = digitCount

        // Decremented by `1` as 10^2 = 100. 100-1 = 99, max 2-digit number
        let maxValue = (pow(10.0, Double(maxValueExponent)) - 1).intValue

        var randomNumber = Int.random(in: .zero...maxValue, using: &rng)

        if shouldAvoidZero && randomNumber == .zero {
            randomNumber = Int.random(in: 1...maxValue, using: &rng)
        }

        return randomNumber
    }
}

// MARK: - ProblemDTO

extension ProblemGenerator {

    struct ProblemDTO {

        var problemString: String
        var solution: Int
        var solved = false

        static var empty = Self(
            problemString: "",
            solution: .zero
        )
    }
}

// MARK: - Operation

extension ProblemGenerator {

    enum Operation: String, CaseIterable {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "*"
        case division = "/"
    }
}

// MARK: - Constants

private extension Int {

    static let maxDigitsCount: Self = 3
}
