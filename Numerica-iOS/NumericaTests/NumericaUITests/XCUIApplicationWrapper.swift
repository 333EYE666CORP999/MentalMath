import XCTest

@MainActor
class XCUIApplicationWrapper {

    typealias Child = XCUIElement

    private let app: XCUIApplication

    var sessionResultsContent: [String] {
        collectionView(with: "SessionResults.View")
            .staticTexts
            .allElementsBoundByIndex
            .map {
                $0.label
            }
    }

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Launch and Terminate


    // MARK: - Button Interactions


    func tapAndAssertButtonLabel(
        buttonIdentifier: String,
        expectedLabel: String,
        postAction: (() -> Void)? = nil
    ) {
        let button = button(with: buttonIdentifier)
        button.tap()
        postAction?()
    }
}

// MARK: - Lifecycle

extension XCUIApplicationWrapper {

    func configureApp(lang: String, locale: String) {
        app.launchArguments = [
            "-AppleLanguages", "(\(lang))",
            "-AppleLocale", "\(locale)"
        ]
        app.launch()
    }

    func launch(with arguments: [String] = []) {
        if !arguments.isEmpty {
            app.launchArguments = arguments
        }
        app.launch()
    }

    func terminateApp() {
        app.terminate()
    }
}

// MARK: - Elements Access

extension XCUIApplicationWrapper {

    func button(with identifier: String) -> Child {
        app.buttons[identifier]
    }

    func collectionView(with identifier: String) -> Child {
        app.collectionViews[identifier]
    }

    func collectionViewCell(with identifier: String) -> Child {
        app.collectionViews.cells[identifier]
    }

    func staticText(with identifier: String) -> Child {
        app.staticTexts[identifier]
    }

    func navigationBar(with identifier: String) -> Child {
        app.navigationBars[identifier]
    }

    func textField(with identifier: String) -> Child {
        app.textFields[identifier]
    }

    func other(with identifier: String) -> Child {
        app.otherElements[identifier]
    }
}

// MARK: - Game Logic

extension XCUIApplicationWrapper {

    @discardableResult
    func play(tries: Int = .random(in: 1...10)) -> Int {
        tapButton(with: "MainView.ActionButton")

        guard tries > 0 else {
            tapButton(with: "MainView.EndButton")
            return .zero
        }

        for number in 0..<tries {
            enterText(
                String(number),
                intoTextFieldWith: "MainView.InputTextField"
            )
            tapButton(with: "MainView.ActionButton")
        }

        tapButton(with: "MainView.EndButton")

        return tries
    }

    func start() {
        tapButton(with: "MainView.ActionButton")
    }

    func end() {
        tapButton(with: "MainView.EndButton")
    }
}

// MARK: - Game Controls

extension XCUIApplicationWrapper {

    func tapButton(with identifier: String) {
        app.buttons[identifier].tap()
    }

    func enterText(
        _ text: String,
        intoTextFieldWith identifier: String,
        shouldTap: Bool = false
    ) {
        let textField = textField(with: identifier)
        if shouldTap {
            textField.tap()
        }
        textField.typeText(text)
    }
}
