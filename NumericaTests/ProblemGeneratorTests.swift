//
//  ProblemGeneratorTests.swift
//  NumericaTests
//
//  Created by Dmitry Aksyonov on 11.09.2024.
//

import XCTest
@testable import Numerica

final class ProblemGeneratorTests: XCTestCase {

    var sut: ProblemGenerator!

    override func setUp() {
        super.setUp()
        sut = ProblemGenerator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testProblemConsistOfThreeParts() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem().problemString

            // Act
            let count = problem.split(separator: .space).count

            // Assert
            XCTAssertEqual(count, 3)
        }
    }

    func testProblemSecondPartIsAlwaysOperator() {
        // Arrange
        let ops = ProblemGenerator.Operation.allCases.map { $0.rawValue }

        // Act
        for _ in 0...100 {
            let problem = sut.getProblem().problemString
            let expectedOperator = String(problem.split(separator: .space)[1])

            // Assert
            XCTAssertTrue(ops.contains(expectedOperator))
        }
    }

    func testLhsAndRhsAreAlwaysNumbers() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem().problemString.split(separator: .space)
            let lhs = "\(problem.map { $0 }[0])".intValue
            let rhs = "\(problem.map { $0 }[2])".intValue

            // Act
            // Assert
            XCTAssertNotNil(lhs)
            XCTAssertNotNil(rhs)
        }
    }

    func testProblemSolutionIsCorrect() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem()
            let problemStringSplitted = problem.problemString.split(separator: .space)

            guard
                let lhs = "\(problemStringSplitted.map { $0 }[0])".intValue,
                let rhs = "\(problemStringSplitted.map { $0 }[2])".intValue
            else {
                XCTFail("Items provided for solution are not numbers")
                return
            }

            guard
                let operation = ProblemGenerator.Operation(rawValue: "\(problemStringSplitted.map { $0 }[1])")
            else {
                XCTFail("No valid operator provided")
                return
            }

            // Act
            let res = switch operation {
            case .addition:
                lhs + rhs
            case .subtraction:
                lhs - rhs
            case .multiplication:
                lhs * rhs
            case .division:
                lhs / rhs
            }

            // Assert
            XCTAssertEqual(res, problem.solution)
        }
    }

    func testDifferentProblemsGenerated() {
        var problems = Set<String>()
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem().problemString

            // Act
            problems.insert(problem)
        }

        // Assert
        XCTAssertGreaterThan(problems.count, 1, "Generator should produce different problems")
    }

    func testEmptyProblemDTOIsValid() {
        // Arrange
        // Act
        let emptyProblem = ProblemGenerator.ProblemDTO.empty

        // Assert
        XCTAssertEqual(emptyProblem.problemString, "")
        XCTAssertEqual(emptyProblem.solution, .zero)
    }

    func testDivisionProblemsAlwaysHaveNonZeroRhs() {
        for _ in 0...100 {
            // Arrange
            let splittedProblemString = sut.getProblem(
                for: .division
            ).problemString.split(
                separator: .space
            ).map(String.init)

            guard
                let rhs = splittedProblemString[2].intValue
            else {
                XCTFail("Not a number returned")
                return
            }

            // Act
            // Assert
            XCTAssertGreaterThan(rhs, .zero)
        }
    }

    func testProblemGeneratesCorrectOperatorOnCertainArguments() {
        for iteration in 0...100 {
            // Arrange
            var operation: ProblemGenerator.Operation

            if iteration < 25 {
                operation = .addition
            } else if iteration >= 25 {
                operation = .subtraction
            } else if iteration >= 50 {
                operation = .multiplication
            } else {
                operation = .division
            }

            let generatedOperator = String(
                sut.getProblem(
                    for: operation
                ).problemString.split(
                    separator: .space
                )[1]
            )

            XCTAssertEqual(operation.rawValue, generatedOperator)
        }
    }

    func testDivisionViaMultiplicationRhsAlwaysNonZero() {
        for _ in 0...100 {
            // Arrange
            // Act
            let divisionProblem = sut.getProblem(
                for: .division
            ).problemString.split(
                separator: .space
            ).map(String.init)

            guard let rhs = divisionProblem[2].intValue else {
                XCTFail("Could not parse number from the given string")
                return
            }

            XCTAssertTrue(rhs > .zero)
        }
    }
}
