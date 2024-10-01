@testable import Numerica
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
@MainActor
final class ProblemGeneratorTests: XCTestCase {

    private var sut: ProblemGenerator!
    // swiftlint:enable implicitly_unwrapped_optional

    private var `operator`: Operator {
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
            let problem = sut.getProblem(for: `operator`).problemString

            // Act
            let count = problem.split(separator: .space).count

            // Assert
            XCTAssertEqual(count, 3)
        }
    }

    func testProblemSecondPartIsAlwaysOperator() {
        // Arrange
        let ops = Operator.allCases.map { $0.rawValue }

        // Act
        for _ in 0...100 {
            let problem = sut.getProblem(for: `operator`).problemString
            let expectedOperator = String(problem.split(separator: .space)[1])

            // Assert
            XCTAssertTrue(ops.contains(expectedOperator))
        }
    }

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
            XCTAssertEqual(res, problem.solution)
        }
    }

    func testDifferentProblemsGenerated() {
        var problems = Set<String>()
        for _ in 0...100 {
            // Arrange
            let problem = sut.getProblem(for: `operator`).problemString

            // Act
            problems.insert(problem)
        }

        // Assert
        XCTAssertGreaterThan(problems.count, 1, "Generator should produce different problems")
    }

    func testEmptyProblemModelIsValid() {
        // Arrange
        // Act
        let emptyProblem = ProblemModel.empty

        // Assert
        XCTAssertEqual(emptyProblem.solution, .zero)
    }

    func testDivisionProblemsAlwaysHaveNonZeroRhs() {
        for _ in 0...100 {
            // Arrange
            // Act
            // Assert
            XCTAssertGreaterThan(
                sut.getProblem(
                    for: .division
                ).rhs,
                .zero
            )
        }
    }

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
            XCTAssertEqual(
                `operator`,
                sut.getProblem(
                    for: `operator`
                ).operator
            )
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
        let operations = Operator.allCases

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
