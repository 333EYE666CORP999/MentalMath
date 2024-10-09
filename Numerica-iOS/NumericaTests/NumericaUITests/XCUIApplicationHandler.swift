import XCTest

@MainActor
final class XCUIApplicationHandler {

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
}

// MARK: - Lifecycle

extension XCUIApplicationHandler {

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
}

// MARK: - Elements Access

extension XCUIApplicationHandler {

    func button(with identifier: String) -> Child {
        app.buttons[identifier]
    }

    func collectionView(with identifier: String) -> Child {
        app.collectionViews[identifier]
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

extension XCUIApplicationHandler {

    @discardableResult
    @MainActor
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
}

// MARK: - Game Controls

extension XCUIApplicationHandler {

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

// MARK: - Basic Wrapper

extension XCUIApplicationHandler {

    static var basic: Self {
        Self(app: XCUIApplication())
    }
}
