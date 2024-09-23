@testable import Numerica
import XCTest

final class LocalizationTests: XCTestCase {

    private var sut: XCUIApplication!
    private var languagesAndLocales: [[String: String]] = []
    private var testBundle = Bundle(for: currentObjectMetatype)

    // Retrieve languages and locales once during setUp
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        sut = XCUIApplication()

        // Retrieve languages and locales once here
        if languagesAndLocales.isEmpty {
            languagesAndLocales = getLanguagesAndLocales()
        }
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // Test for "START" button localization on all languages
    func testStartButtonOnAllLanguages() {
        testButtonLocalization(for: "START", buttonId: "MainView.ActionButton")
    }

    // Test for "SUBMIT" button localization on all languages
    func testSubmitButtonTitleOnAllLanguages() {
        testButtonLocalization(for: "SUBMIT", buttonId: "SubmitButton")
    }

    // Generalized function to test button localization
    private func testButtonLocalization(for key: String, buttonId: String) {
        for element in languagesAndLocales {
            guard
                let lang = element["-AppleLanguage"],
                let locale = element["-AppleLocale"],
                let localizedString = getLocalizedString(for: key, language: lang, locale: locale)
            else {
                XCTFail("Failed to retrieve localization data for \(key)")
                continue
            }

            configureApp(language: lang, locale: locale)
            sut.launch()

            let buttonText = sut.buttons[buttonId].label

            XCTAssertEqual(
                buttonText,
                localizedString,
                """
                Button text: \(buttonText) is not equal to localized string: \(localizedString) \
                on locale: \(locale) and language: \(lang)
                """
            )
        }
    }
}

// MARK: - Helper Functions
private extension LocalizationTests {

    typealias Info = [String: [[String: String]]]

    // This function retrieves the languages and locales only once
    func getLanguagesAndLocales() -> [[String: String]] {
        guard let url = Bundle(for: type(of: self)).url(
            forResource: "languages_and_locales",
            withExtension: "json"
        ) else {
            XCTFail("Failed to find languages_and_locales.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            guard let info = try? JSONSerialization.jsonObject(with: data) as? Info else {
                XCTFail("Failed to parse languages_and_locales.json")
                return []
            }
            return info["languages_and_locales"] ?? []
        } catch {
            XCTFail("Failed to load languages and locales: \(error.localizedDescription)")
            return []
        }
    }

    // Configure app with the specified language and locale
    func configureApp(language: String, locale: String) {
        sut.launchArguments = [
            "-AppleLanguages", "\(language)",
            "-AppleLocale", "\(locale)"
        ]
    }

    // Retrieve the localized string for a given key, language, and locale
    func getLocalizedString(for key: String, language: String, locale: String) -> String? {
        guard let lprojPath = Bundle(for: type(of: self)).path(forResource: language, ofType: "lproj") else {
            XCTFail("Could not retrieve lproj path for language: \(language), locale: \(locale)")
            return nil
        }

        guard let localizationBundle = Bundle(path: lprojPath) else {
            XCTFail("Could not retrieve localization bundle for language: \(language)")
            return nil
        }

        return localizationBundle
            .localizedString(
                forKey: key,
                value: nil,
                table: nil
            )
    }
}
