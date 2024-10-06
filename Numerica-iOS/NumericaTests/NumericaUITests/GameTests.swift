//
//  GameTests.swift
//  NumericaTests
//
//  Created by Dmitry Aksyonov on 06.10.2024.
//

@testable import Numerica
import XCTest

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
            sut.launch()
        }
    }

    override func tearDown() async throws {
        await MainActor.run {
            sut = nil
        }

        try await super.tearDown()
    }

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
}

private extension GameTests {

    @MainActor
    func makeApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        return app
    }
}
