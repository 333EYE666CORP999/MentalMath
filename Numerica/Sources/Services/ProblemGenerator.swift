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

        let problem = [
            getRandomNumber().stringValue,
            " ",
            composedOperation.rawValue,
            " ",
            getRandomNumber(excludeZeroRhs: operation == .division).stringValue
        ].joined()

        return ProblemDTO(
            problemString: problem,
            solution: solve(expression: problem)
        )
    }
}

// MARK: - ProblemDTO

extension ProblemGenerator {

    struct ProblemDTO {

        var id: UUID = UUID()

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

// MARK: - Expression Calc

private extension ProblemGenerator {

    func solve(expression: String) -> Int {
        let components = expression.split(
            separator: " "
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
        let transformableProblem = constructProblem(for: .multiplication)
        let components = transformableProblem.problemString.split(separator: "")

        guard
            let lhs = String(components[0]).intValue,
            let rhs = String(components[2]).intValue
        else {
            return .empty
        }

        let product = lhs * rhs
        let divisionProblemString = [
            product.stringValue,
            Operation.division.rawValue,
        ].joined(separator: " ")

    }

    private func constructProblem(
        for operation: Operation
    ) -> ProblemDTO {
        let problemString = [
            getRandomNumber().stringValue,
            operation.rawValue,
            getRandomNumber().stringValue
        ].joined(separator: " ")

        return ProblemDTO(
            problemString: problemString,
            solution: solve(expression: problemString)
        )
    }


    private func getRandomNumber(maxDigitCount: Int, nonZero: Bool = false) -> Int {
        // Ensure the digitCount is at least 1
        guard maxDigitCount > 0 else {
            fatalError("UpperBound digit count must be greater than zero.")
        }

        // Decremented by `1` as 2-digit value means 10^1 and so on
        let minValueExponent = digitCount - 1
        let maxValueExponent = digitCount

        let minValue = (pow(10.0, minValueExponent)).intValue
        // Decremented by `1` as 10^2 = 100. 100-1 = 99, max 2-digit number
        let maxValue = (pow(10.0, maxValueExponent) - 1).intValue

        let randomNumber = Int.random(in: minValue...maxValue)

        return if excludeZeroRhs, randomNumber == .zero {
            Int.random(in: 1...maxValue)
        } else {
            Int.random(in: minValue...maxValue)
        }
    }
}
