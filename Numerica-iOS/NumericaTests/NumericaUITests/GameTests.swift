//
//  GameTests.swift
//  NumericaTests
//
//  Created by Dmitry Aksyonov on 06.10.2024.
//

@testable import Numerica
import XCTest

// MARK: - GameTests

@preconcurrency
final class GameTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    @MainActor private var sut: XCUIApplication!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false

        await MainActor.run {
            sut = makeApp()
        }
    }

    override func tearDown() async throws {
        await MainActor.run {
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
        sut.buttons["MainView.ActionButton"].tap()

        // Assert
        XCTAssert(sut.staticTexts["MainView.ProblemView"].exists)
        XCTAssert(sut.buttons["MainView.EndButton"].exists)
        XCTAssert(sut.buttons["MainView.ActionButton"].exists)
        XCTAssert(sut.textFields["MainView.InputTextField"].exists)
    }

    @MainActor
    func testGameStopsWhenUserPressesEndButton() {
        // Arrange
        // Act
        play()

        // Assert
        XCTAssert(sut.buttons["MainView.ActionButton"].exists)
        XCTAssert(!sut.staticTexts["MainView.ProblemView"].exists)
        XCTAssert(!sut.buttons["MainView.EndButton"].exists)
        XCTAssert(!sut.textFields["MainView.InputTextField"].exists)
        XCTAssert(!sut.otherElements["SessionResults.View"].exists)
    }

    @MainActor
    func testSessionResultsIsShownWhenAtLeasOneAnswerGiven() {
        // Arrange
        // Act
        play()

        // Assert
        assertSessionResultsViewExists()
    }

    @MainActor
    func testSessionResultsCountCorrespondsWithAnswersCount() {
        // Arrange
        // Act
        let answersCount = play()

        // Assert
        assertSessionResultsViewExists()
        XCTAssertEqual(
            answersCount,
            sut.collectionViews["SessionResults.View"].cells.count
        )
    }

    @MainActor
    func testSessionResultsRendersContent() {
        // Arrange
        // Act
        play()

        // Assert
        assertSessionResultsViewExists()
        sut
            .collectionViews["SessionResults.View"]
            .staticTexts
            .allElementsBoundByIndex
            .map {
                $0.label
            }
            .enumerated()
            .forEach { idx, value in
                switch idx % 3 {
                case 0:
                    let problemStirng = value.split(separator: " ").map(String.init)
                    XCTAssertEqual(problemStirng.count, 3)
                    XCTAssertNotNil(Int(problemStirng[0]))
                    XCTAssertTrue(["+", "-", "*", "/"].contains(problemStirng[1]))
                    XCTAssertNotNil(Int(problemStirng[2]))
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
        XCTAssert(sut.collectionViews["SessionResults.View"].exists)
        XCTAssert(sut.navigationBars["SESSION RESULTS"].exists)
        XCTAssert(sut.staticTexts["SESSION RESULTS"].exists)
        XCTAssert(sut.buttons["Back"].exists)
    }

    @MainActor
    func makeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        return app
    }

    @MainActor
    func tap(button identifier: String) {
        sut.buttons[identifier].tap()
    }

    @MainActor
    @discardableResult
    func play() -> Int {
        let answersCount = Int.random(in: 0...10)
        tap(button: "MainView.ActionButton")

        if answersCount > 0 {
            for number in 0..<answersCount {
                answer(String(number))
            }
        }

        tap(button: "MainView.EndButton")

        return answersCount
    }

    @MainActor
    func answer(_ answer: String) {
        sut.textFields["MainView.InputTextField"].typeText(answer)
        tap(button: "MainView.ActionButton")
    }
}

// MARK: - Constants

private extension String {

    static let problemSolutionStatuses = ["❌", "✅"]
}
