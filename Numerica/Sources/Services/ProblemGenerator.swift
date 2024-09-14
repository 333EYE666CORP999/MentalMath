//
//  File.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation

// MARK: - MathGen

final class ProblemGenerator {

    func getProblem(for selected: Operation? = nil) -> ProblemDTO {
        let operation: Operation? = if let selected {
            selected
        } else if let randomOperation = Operation.allCases.randomElement() {
            randomOperation
        } else {
            nil
        }

        guard let composedOperation = operation else { return .empty }

        return composedOperation != .division
        ? constructProblem(for: composedOperation)
        : constructDivisionOperationProblem()
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

    private func constructProblem(
        for operation: Operation,
        avoidZero: Bool = false
    ) -> ProblemDTO {
        let problemString = [
            getRandomNumber().stringValue,
            operation.rawValue,
            getRandomNumber(avoidZero: operation == .division).stringValue
        ].joined(separator: .space)

        return ProblemDTO(
            problemString: problemString,
            solution: solve(expression: problemString)
        )
    }


    private func getRandomNumber(
        maxDigitsCount: Int = .maxDigitsCount,
        avoidZero: Bool = false
    ) -> Int {
        // Ensure the maxDigitsCount is at least 1
        guard maxDigitsCount > .zero else {
            assertionFailure("Max digits count must be greater than zero.")
            return Int.random(in: 1...2)
        }

        // Random digit count in range from 1 to maxDigitsCount
        let digitCount = Int.random(in: 1...maxDigitsCount)

        // Decremented by `1` as 2-digit value means 10^1 and so on
        let minValueExponent = digitCount - 1
        let maxValueExponent = digitCount

        let minValue = pow(10.0, Double(minValueExponent)).intValue
        // Decremented by `1` as 10^2 = 100. 100-1 = 99, max 2-digit number
        let maxValue = (pow(10.0, Double(maxValueExponent)) - 1).intValue

        var randomNumber = Int.random(in: minValue...maxValue)

        // Ensure the random number is non-zero if the flag is set
        if avoidZero && randomNumber == .zero {
            randomNumber = Int.random(in: 1...maxValue) // Regenerate a number in the valid range excluding zero
        }

        return randomNumber
    }
}

// MARK: - ProblemDTO

extension ProblemGenerator {

    struct ProblemDTO {

        var problemString: String
        var solution: Int
        var solved: Bool = false

        static var empty: Self = ProblemDTO(
            problemString: "",
            solution: .zero
        )
    }
}

// MARK: - Operation

extension ProblemGenerator {

    enum Operation: String, CaseIterable {
        case addition =         "+"
        case subtraction =      "-"
        case multiplication =   "*"
        case division =         "/"
    }
}

// MARK: - Constants

private extension Int {

    static let maxDigitsCount: Self = 3
}
