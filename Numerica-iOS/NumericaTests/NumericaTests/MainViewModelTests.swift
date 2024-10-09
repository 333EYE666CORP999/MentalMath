import Combine
@testable import Numerica
import SwiftData
import XCTest

@preconcurrency
final class MainViewModelTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var sut: MainViewModel!
    private var mockStorageService: MockStorageService!
    private var mockProblemGenerator: MockProblemGenerator!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() async throws {
        try await super.setUp()
        mockStorageService = MockStorageService()
        mockProblemGenerator = await MockProblemGenerator()
        await MainActor.run {
            sut = MainViewModel(
                storageService: mockStorageService,
                problemGenerator: mockProblemGenerator
            )
        }
    }

    override func tearDown() {
        sut = nil
        mockStorageService = nil
        mockProblemGenerator = nil
        super.tearDown()
    }

    @MainActor
    func testStartSessionResetsGame() {
        sut.onActionButtonTap()
        XCTAssertTrue(sut.userInput.isEmpty)
        XCTAssertTrue(sut.isGameStarted)
        XCTAssertEqual(sut.actionButtonText, "SUBMIT")
        XCTAssertFalse(sut.problem.problemString.isEmpty)
    }

    @MainActor
    func testProcessCorrectAnswer() {
        mockProblemGenerator.stubbedProblem = ProblemModel(
            lhs: 5,
            operation: .addition,
            rhs: 5,
            solution: 10
        )
        sut.onActionButtonTap()  // Start game
        sut.userInput = "10"
        sut.onActionButtonTap()  // Submit correct answer

        XCTAssertEqual(
            sut.sessionResults.count { $0.solved }, 1
        )
        XCTAssertEqual(
            sut.sessionResults.count { !$0.solved }, 0
        )
    }

    @MainActor
    func testProcessIncorrectAnswer() {
        mockProblemGenerator.stubbedProblem = ProblemModel(
            lhs: 5,
            operation: .addition,
            rhs: 5,
            solution: 10
        )
        sut.onActionButtonTap()  // Start game
        sut.userInput = "11"
        sut.onActionButtonTap()  // Submit correct answer

        XCTAssertEqual(
            sut.sessionResults.count { $0.solved }, 0
        )
        XCTAssertEqual(
            sut.sessionResults.count { !$0.solved }, 1
        )
    }

    @MainActor
    func testSessionResultsProperlyShowsCorrectAndIncorrectAnswers() {
        mockProblemGenerator.stubbedProblem = ProblemModel(
            lhs: 3,
            operation: .multiplication,
            rhs: 3,
            solution: 9
        )
        sut.onActionButtonTap()  // Start game

        sut.userInput = "9"  // Correct answer
        sut.onActionButtonTap()

        mockProblemGenerator.stubbedProblem = ProblemModel(
            lhs: 2,
            operation: .multiplication,
            rhs: 2,
            solution: 4
        )
        sut.userInput = "3"  // Incorrect answer
        sut.onActionButtonTap()

        sut.onEndButtonTap()

        XCTAssertEqual(sut.sessionResults.count, 2)
        XCTAssertTrue(sut.sessionResults[0].solved)  // First answer correct
        XCTAssertFalse(sut.sessionResults[1].solved)  // Second answer incorrect
    }

    @MainActor
    func testEndSessionSavesResults() {
        sut.onActionButtonTap() // Start game
        sut.onEndButtonTap() // End game
        XCTAssertTrue(mockStorageService.saveCalled)
    }

    @MainActor
    func testErrorPlaceholderShownOnEmptyInput() {
        sut.onActionButtonTap()
        sut.onActionButtonTap()

        XCTAssertEqual(
            sut.placeholderText,
            "INPUT NUMBER".localized
        )
        XCTAssertEqual(
            sut.placeholderColor,
            .red
        )
    }

    @MainActor
    func testErrorPlaceholderResetsAfterOneSecond() {
        sut.onActionButtonTap()
        sut.onActionButtonTap()

        let expectation = self.expectation(
            description: "Wait 1 sec till error content resets"
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.sut.placeholderText.isEmpty)
            XCTAssertEqual(self.sut.placeholderColor, .gray)
            XCTAssertFalse(self.sut.showingError)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) {
            guard $0 == nil else {
                XCTFail("Expectation failed with error: \(String(describing: $0))")
                return
            }
        }
    }
}

// MARK: - Mock Classes

final class MockStorageService: StorageServiceInput {

    var saveCalled = false

    func save<T>(_ model: T) where T: PersistentModel {
        saveCalled = true
    }
}

final class MockProblemGenerator: ProblemGeneratorInput {

    var stubbedProblem: ProblemModel = .empty

    func getProblem(for selected: Operator) -> ProblemModel {
        stubbedProblem
    }
}
