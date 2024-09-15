//
//  File.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation

// MARK: - MathGen

final class ProblemGenerator {

    private static var rng = SystemRandomNumberGenerator()

    func getProblem(for selected: Operation) -> ProblemDTO {
        selected == .division
        ? constructDivisionOperationProblem()
        : constructProblem(for: selected)
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
        let randomNumber = Int.random(in: 0...1, using: &Self.rng)

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

        static var random: Self {
            guard
                let random = Self.allCases.randomElement(
                    using: &ProblemGenerator.rng
                )
            else {
                return .subtraction
            }

            return random
        }

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
