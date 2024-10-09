import Foundation
@testable import Numerica
import Testing

@Suite("Problem Generator Tests")
@MainActor
struct ProblemGeneratorTests {

    // swiftlint:disable implicitly_unwrapped_optional
    var sut: ProblemGenerator!
    // swiftlint:enable implicitly_unwrapped_optional

    private var `operator`: Operator {
        .random
    }

    init() {
        self.sut = ProblemGenerator()
    }

    @Test("Test that problem is always correctly constructed")
    func testProblemConsistOfThreeParts() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem(for: `operator`).problemString

            // Act
            let count = problem.split(separator: .space).count

            // Assert
            #expect(count == 3)
        }
    }

    @Test("Test that problem always has an operator")
    func testProblemSecondPartIsAlwaysOperator() {
        // Arrange
        let ops = Operator.allCases.map { $0.rawValue }

        // Act
        for _ in 0...100 {
            let problem = sut.getProblem(for: `operator`).problemString
            let expectedOperator = String(problem.split(separator: .space)[1])

            // Assert
            #expect(ops.contains(expectedOperator))
        }
    }

    @Test("Test that problem always has a solution")
    func testProblemSolutionIsCorrect() {
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem(for: `operator`)

            // Act
            let res = switch problem.`operator` {
            case .addition:
                problem.lhs + problem.rhs
            case .subtraction:
                problem.lhs - problem.rhs
            case .multiplication:
                problem.lhs * problem.rhs
            case .division:
                problem.lhs / problem.rhs
            }

            // Assert
            #expect(res == problem.solution)
        }
    }

    @Test("Test that generator produces different problems")
    func testDifferentProblemsGenerated() {
        var problems = Set<String>()
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem(for: `operator`).problemString

            // Act
            problems.insert(problem)
        }

        // Assert
        #expect(problems.count > 1, "Generator should produce different problems")
    }

    @Test("Test that empty problem model is valid")
    func testEmptyProblemModelIsValid() {
        // Arrange
        // Act
        let emptyProblem = ProblemModel.empty

        // Assert
        #expect(emptyProblem.solution == .zero)
    }

    @Test("Test that addition problems always have non-zero rhs")
    func testDivisionProblemsAlwaysHaveNonZeroRhs() {
        for _ in 0...100 {
            // Arrange
            // Act
            // Assert
            #expect(
                sut.getProblem(for: .division).rhs > .zero
            )
        }
    }

    @Test("Test that problem generator generates correct operator")
    func testProblemGeneratesCorrectOperatorOnCertainArguments() {
        for iteration in 0...100 {
            // Arrange
            var `operator`: Operator

            if iteration < 25 {
                `operator` = .addition
            } else if iteration >= 25 {
                `operator` = .subtraction
            } else if iteration >= 50 {
                `operator` = .multiplication
            } else {
                `operator` = .division
            }

            // Act
            // Assert
            #expect(
                `operator` == sut.getProblem(for: `operator`).operator
            )
        }
    }

    @Test("Test that division via multiplication rhs is always non-zero")
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
                Issue.record("Could not parse number from the given string")
                return
            }

            // Assert
            #expect(rhs > .zero)
        }
    }

    @Test
    func testOperationsContainProperItems() {
        // Arrange
        let operations = Operator.allCases

        // Act
        // Assert
        operations.enumerated().forEach { idx, value in
            switch idx {
            case .zero:
                #expect(value.rawValue == "+")
            case 1:
                #expect(value.rawValue == "-")
            case 2:
                #expect(value.rawValue == "*")
            case 3:
                #expect(value.rawValue == "/")
            default:
                Issue.record("Number of operations exceeds the needed number (4)")
            }
        }
    }

    @Test
    func testOperationRandomness() {
        // Arrange
        let symbols = ["+", "-", "*", "/"]
        let numberOfOperations = 1000
        var frequency = [String: Int]()
        symbols.forEach {
            frequency[$0] = 0
        }

        // Act
        for _ in .zero...numberOfOperations {
            let `operator` = String(
                sut.getProblem(
                    for: self.`operator`
                ).problemString.split(
                    separator: .space
                )[1]
            )

            guard frequency[`operator`] != nil else {
                Issue.record("Got operator that should not be generated")
                return
            }

            frequency[`operator`]? += 1
        }

        let expectedFrequency = Double(numberOfOperations / symbols.count)
        var chiSquare = 0.0

        symbols.forEach {
            guard let observedFrequency = frequency[$0]?.doubleValue else {
                Issue.record("Got operator that should not be generated")
                return
            }
            chiSquare += pow(observedFrequency - expectedFrequency, 2) / expectedFrequency
        }

        let threshold: Double = 400

        // Assert
        #expect(chiSquare >= threshold)
    }
}
