import XCTest

// MARK: - GameTests

@preconcurrency
final class GameTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    @MainActor private var sut: XCUIApplicationHandler!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false

        await MainActor.run {
            sut = XCUIApplicationHandler()
            sut.configureApp(lang: "en", locale: "en-US")
            sut.launch()
        }
    }

    override func tearDown() async throws {
        await MainActor.run {
            sut.terminate()
            sut = nil
        }

        try await super.tearDown()
    }
}

// MARK: - Tests

extension GameTests {

    @MainActor
    func testGameLaunchesWithProperUIElements() {
        // Arrange
        // Act
        sut.tapButton(with: "MainView.ActionButton")

        // Assert
        XCTAssert(sut.button(with: "MainView.EndButton").exists)
        XCTAssert(sut.staticText(with: "MainView.ProblemView").exists)
        XCTAssert(sut.textField(with: "MainView.InputTextField").exists)
        XCTAssert(sut.button(with: "MainView.ActionButton").exists)
    }

    @MainActor
    func testGameStopsWhenUserPressesEndButton() {
        // Arrange
        // Act
        sut.play()

        // Assert
        XCTAssert(sut.button(with: "MainView.ActionButton").exists)
        XCTAssert(!sut.button(with: "MainView.ProblemView").exists)
        XCTAssert(!sut.button(with: "MainView.EndButton").exists)
        XCTAssert(!sut.textField(with: "MainView.InputTextField").exists)
        XCTAssert(!sut.other(with: "SessionResults.View").exists)
    }

    @MainActor
    func testGameResultsShownWhenAtLeasOneAnswerGiven() {
        // Arrange
        // Act
        sut.play()

        // Assert
        assertSessionResultsViewExists()
    }

    /// Tests correspondence between results count and answers given
    /// - Note: нужно преписать, чтоб тест проходил, когда есть ячейки за видимой зоной.
    /// Сейчас сыпет ошибкой, если ячеек больше, чем видимая область
    @MainActor
    func testGameResultsCountEqualsAnswersCount() {
        // Arrange
        // Act
        for iteration in 1...4 {
            let answersCount = sut.play(iteration)

            // Assert
            assertSessionResultsViewExists()
            XCTAssertEqual(
                answersCount,
                sut.collectionView(with: "SessionResults.View").cells.count
            )
        }
    }

    @MainActor
    func testSessionResultsRendersContent() {
        // Arrange
        // Act
        sut.play(10)

        // Assert
        assertSessionResultsViewExists()
        sut.sessionResultsContent.enumerated().forEach { idx, value in
            switch idx % 3 {
            case 0:
                assertProblemStringIsValid(value)
            case 1:
                XCTAssertNotNil(Int(value))
            case 2:
                XCTAssertTrue(String.problemSolutionStatuses.contains { $0 == value })
            default:
                break
            }
        }
    }
}

// MARK: - Helpers

private extension GameTests {

    @MainActor
    func assertSessionResultsViewExists() {
        XCTAssert(sut.collectionView(with: "SessionResults.View").exists)
        XCTAssert(sut.navigationBar(with: "SESSION RESULTS").exists)
        XCTAssert(sut.staticText(with: "SESSION RESULTS").exists)
        XCTAssert(sut.button(with: "Back").exists)
    }

    @MainActor
    func assertProblemStringIsValid(_ problem: String) {
        let problemStirng = problem.split(separator: " ").map(String.init)
        XCTAssertEqual(problemStirng.count, 3)
        XCTAssertNotNil(Int(problemStirng[0]))
        XCTAssertTrue(["+", "-", "*", "/"].contains(problemStirng[1]))
        XCTAssertNotNil(Int(problemStirng[2]))
    }
}

// MARK: - Constants

private extension String {

    static let problemSolutionStatuses = ["❌", "✅"]
}
