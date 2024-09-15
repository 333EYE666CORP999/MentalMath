//
//  ProblemGeneratorTests.swift
//  NumericaTests
//
//  Created by Dmitry Aksyonov on 11.09.2024.
//

@testable import Numerica
import XCTest

// swiftlint:disable test_case_accessibility
// swiftlint:disable implicitly_unwrapped_optional
final class ProblemGeneratorTests: XCTestCase {

    typealias Operation = ProblemGenerator.Operation
    // swiftlint:enable test_case_accessibility

    private var sut: ProblemGenerator!
    // swiftlint:enable implicitly_unwrapped_optional

    private var operation: Operation {
        .random
    }

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
            let problem = sut.getProblem(for: operation).problemString

            // Act
            let count = problem.split(separator: .space).count

            // Assert
            XCTAssertEqual(count, 3)
        }
    }

    func testProblemSecondPartIsAlwaysOperator() {
        // Arrange
        let ops = Operation.allCases.map { $0.rawValue }

        // Act
        for _ in 0...100 {
            let problem = sut.getProblem(for: operation).problemString
            let expectedOperator = String(problem.split(separator: .space)[1])

            // Assert
            XCTAssertTrue(ops.contains(expectedOperator))
        }
    }

    func testProblemSolutionIsCorrect() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem(for: operation)
            let problemStringSplitted = Array(problem.problemString.split(separator: .space))

            guard
                let lhs = "\(problemStringSplitted[0])".intValue,
                let rhs = "\(problemStringSplitted[2])".intValue
            else {
                XCTFail("Items provided for solution are not numbers")
                return
            }

            guard
                let operation = Operation(rawValue: "\(problemStringSplitted[1])")
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
            let problem = sut.getProblem(for: operation).problemString

            // Act
            problems.insert(problem)
        }

        // Assert
        XCTAssertGreaterThan(problems.count, 1, "Generator should produce different problems")
    }

    func testLhsAndRhsAreAlwaysNumbers() {
        for _ in 0...100 {
            // Arrange
            let problem = Array(
                sut.getProblem(for: operation).problemString.split(separator: .space)
            )
            let lhs = "\(problem[0])".intValue
            let rhs = "\(problem[2])".intValue

            // Act
            // Assert
            XCTAssertNotNil(lhs)
            XCTAssertNotNil(rhs)
        }
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
            var operation: Operation

            if iteration < 25 {
                operation = .addition
            } else if iteration >= 25 {
                operation = .subtraction
            } else if iteration >= 50 {
                operation = .multiplication
            } else {
                operation = .division
            }
            // Act
            let generatedOperator = String(
                sut.getProblem(
                    for: operation
                ).problemString.split(
                    separator: .space
                )[1]
            )

            // Assert
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

            // Assert
            XCTAssertTrue(rhs > .zero)
        }
    }

    func testOperationsContainProperItems() {
        // Arrange
        let operations = Operation.allCases

        // Act
        // Assert
        operations.enumerated().forEach { idx, value in
            switch idx {
            case .zero:
                XCTAssertEqual(value.rawValue, "+")
            case 1:
                XCTAssertEqual(value.rawValue, "-")
            case 2:
                XCTAssertEqual(value.rawValue, "*")
            case 3:
                XCTAssertEqual(value.rawValue, "/")
            default:
                XCTFail("Number of operations exceeds the needed number (4)")
            }
        }
    }

    func testOperationRandomness() {
        // Arrange
        let symbols = ["+", "-", "*", "/"]
        var numberOfOperations = 1000
        var frequency = [String: Int]()
        symbols.forEach {
            frequency[$0] = 0
        }

        // Act
        for _ in .zero...numberOfOperations {
            let `operator` = String(
                sut.getProblem(
                    for: self.operation
                ).problemString.split(
                    separator: .space
                )[1]
            )

            guard frequency[`operator`] != nil else {
                XCTFail("Got operator that should not be generated")
                return
            }

            frequency[`operator`]? += 1
        }

        let expectedFrequency = Double(numberOfOperations / symbols.count)
        var chiSquare = 0.0

        symbols.forEach {
            guard let observedFrequency = frequency[$0]?.doubleValue else {
                XCTFail("Got operator that should not be generated")
                return
            }
            chiSquare += pow(observedFrequency - expectedFrequency, 2) / expectedFrequency
        }

        let threshold = 7.81
        // Assert
        // FIXME: - make XCTASSERTEQUAL
        print("chiSquare: \(chiSquare), threshold: \(threshold)")
    }
}
