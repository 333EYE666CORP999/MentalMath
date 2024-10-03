@testable import Numerica
import XCTest

@preconcurrency
final class LocalizationTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var sut: XCUIApplication!
    // swiftlint:enable implicitly_unwrapped_optional

    private var languagesAndLocales: [[String: String]] = []
    private let testBundle = Bundle(for: LocalizationTests.self)
    private var randomLocaleCount: Int {
        .random(in: 5...10)
    }

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        sut = await XCUIApplication()
        languagesAndLocales = Array(
            loadLanguagesAndLocales()
                .shuffled()
                .prefix(randomLocaleCount)
        )
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func testStartButtonLocalization() async {
        await testButtonLocalization(
            buttonIdentifier: "MainView.ActionButton",
            labelKey: "START"
        )
    }

    func testSubmitButtonLocalizationAfterStart() async {
        await testButtonLocalization(
            buttonIdentifier: "MainView.ActionButton"
        ) { button, lang, locale in
            await button.tap()
            await self.assertButtonLabel(
                button,
                key: "SUBMIT",
                lang: lang,
                locale: locale
            )
        }
    }
}

private extension LocalizationTests {

    private typealias Info = [String: [[String: String]]]

    func testButtonLocalization(
        buttonIdentifier: String,
        labelKey: String = "",
        postAction: (XCUIElement, String, String) async -> Void = { _, _, _ in () }
    ) async {
        for localeData in languagesAndLocales {
            guard
                let lang = localeData["-AppleLanguage"],
                let locale = localeData["-AppleLocale"]
            else {
                return
            }

            await configureApp(lang: lang, locale: locale)

            let button = await sut.buttons[buttonIdentifier]

            guard !labelKey.isEmpty else {
                await postAction(button, lang, locale)
                return
            }

            await assertButtonLabel(
                button,
                key: labelKey,
                lang: lang,
                locale: locale
            )

            await postAction(button, lang, locale)
        }
    }

    func assertButtonLabel(
        _ button: XCUIElement,
        key: String,
        lang: String,
        locale: String
    ) async {
        let localizedString = getLocalizedString(
            for: key,
            language: lang,
            locale: locale
        )

        let label = await button.label

        XCTAssertEqual(
            label,
            localizedString,
            "Button label mismatch for key: \(key) in \(lang)-\(locale)"
        )
    }

    @MainActor
    func configureApp(lang: String, locale: String) {
        sut.launchArguments = [
            "-AppleLanguages", "(\(lang))",
            "-AppleLocale", "\(locale)"
        ]
        sut.launch()
    }

    func getLocalizedString(
        for key: String,
        language: String,
        locale: String
    ) -> String? {
        guard
            let bundlePath = testBundle.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath)
        else {
            XCTFail("Missing localization for \(language)-\(locale)")
            return nil
        }

        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func loadLanguagesAndLocales() -> [[String: String]] {
        guard
            let url = testBundle.url(forResource: "languages_and_locales", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let parsedData = try? JSONSerialization.jsonObject(with: data) as? Info,
            let langs = parsedData["languages_and_locales"]
        else {
            XCTFail("Error loading languages and locales")
            return []
        }

        return langs
    }
}