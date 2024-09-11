//
//  File.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation

// MARK: - MathGen

final class ProblemGenerator {

    // TODO: - предусмотреть, чтобы не давало деления на ноль
    // TODO: - покрыть тестами
    func getProblem() -> ProblemDTO {
        guard
            let op = Operation.allCases.randomElement()
        else { return .empty }

        let problem = [
            getRandomNumber().stringValue,
            " ",
            op.rawValue,
            " ",
            getRandomNumber(excludeZeroRhs: op == .division).stringValue
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

    // TODO: - покрыть тестами
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
            // FIXME: - возвращать ноль не круто, подумать, реально ли здесь что нужно допилить в плане ошибок
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

    /// Generates a random number within a random digits count
    /// - Returns: Generated random number
    // TODO: - покрыть тестами
    private func getRandomNumber(excludeZeroRhs: Bool = false) -> Int {
        let digitCount = Int.random(in: 1...4)

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
