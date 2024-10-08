@testable import Numerica
import XCTest

// MARK: - LocalizationTests

@preconcurrency
final class LocalizationTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    @MainActor private var sut: XCUIApplication!
    // swiftlint:enable implicitly_unwrapped_optional

    private var languagesAndLocales: [[String: String]] = []
    private let testBundle = Bundle(for: LocalizationTests.self)

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false

        await MainActor.run {
            sut = XCUIApplication()
        }

        languagesAndLocales = Array(
            getLanguagesAndLocales()
                .shuffled()
        )
    }

    override func tearDown() async throws {
        await MainActor.run {
            sut = nil
        }

        try await super.tearDown()
    }
}

// MARK: - Tests

extension LocalizationTests {

    func testStartButtonLocalization() async {
        await testButtonLocalization(
            buttonIdentifier: "MainView.ActionButton",
            labelKey: "START"
        )
    }

    func testSubmitButtonLocalizationAfterStart() async {
        await testButtonLocalization(
            buttonIdentifier: "MainView.ActionButton"
        ) { button, lang, locale async in
            await MainActor.run {
                button.tap()
            }
            await self.assertButtonLabel(
                button,
                key: "SUBMIT",
                lang: lang,
                locale: locale
            )
        }
    }

    func testLangsStubMatchesLocalizationLanguages() {
        var notFoundLanguages = [String]()

        languagesAndLocales.forEach { element in
            guard
                let langCode = element["-AppleLanguage"],
                let url = Bundle(for: Self.self).url(
                    forResource: "\(langCode)",
                    withExtension: "lproj"
                )
            else {
                notFoundLanguages.append(element["-AppleLanguage"] ?? "")
                return
            }

            XCTAssertTrue(
                notFoundLanguages.isEmpty,
                "Some langs missing in Localizable: \(notFoundLanguages)"
            )
        }
    }
}

// MARK: - Helpers

extension LocalizationTests {

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

        await MainActor.run {
            let label = button.label

            XCTAssertEqual(
                label,
                localizedString,
                "Button label mismatch for key: \(key) in \(lang)-\(locale)"
            )
        }
    }

    func configureApp(lang: String, locale: String) async {
        await MainActor.run {
            sut.launchArguments = [
                "-AppleLanguages", "(\(lang))",
                "-AppleLocale", "\(locale)"
            ]
            sut.launch()
        }
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

    func getLanguagesAndLocales() -> [[String: String]] {
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
