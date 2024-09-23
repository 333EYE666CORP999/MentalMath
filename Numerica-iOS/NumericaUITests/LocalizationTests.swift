//
//  LocalizationTests.swift
//  NumericaUITests
//
//  Created by Dmitry Aksyonov on 22.09.2024.
//

@testable import Numerica
import XCTest

// swiftlint:disable implicitly_unwrapped_optional
final class LocalizationTests: XCTestCase {

    // swiftlint:disable implicitly_unwrapped_optional
    private var sut: XCUIApplication!
    // swiftlint:enable implicitly_unwrapped_optional
    private var languagesAndLocales: [[String: String]] = []
    private var testBundle = Bundle(for: currentObjectMetatype)

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        sut = XCUIApplication()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testStartButtonOnAllLanguages() {
        for element in languagesAndLocales {
            guard
                let lang = element["-AppleLanguage"],
                let locale = element["-AppleLocale"],
                let localizedString = getLocalizedString(
                    for: "START",
                    language: lang,
                    locale: locale
                )
            else {
                XCTFail("non retrieved data from localization array")
                return
            }

            configureApp(language: lang, locale: locale)
            sut.launch()
            let buttonText = getuButton(for: "MainView.ActionButton").label

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

    func testSubmitButtonTitleOnAllLanguages() {
        for element in languagesAndLocales {
            guard
                let lang = element["-AppleLanguage"],
                let locale = element["-AppleLocale"],
                let localizedString = getLocalizedString(
                    for: "SUBMIT",
                    language: lang,
                    locale: locale
                )
            else {
                XCTFail("non retrieved data from localization array")
                return
            }
        }
    }
}

private extension LocalizationTests {

    private typealias Info = [String: [[String: String]]]

    func getLanguagesAndLocales() -> [[String: String]] {
        guard let url = testBundle.url(
            forResource: "languages_and_locales",
            withExtension: "json"
        ) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            guard
                let info = try? JSONSerialization.jsonObject(with: data) as? Info,
                let langs = info["languages_and_locales"]
            else {
                return []
            }
            return langs
        } catch let error as NSError {
            XCTFail(
                error.userInfo.map { "\($0): \($1)" }.joined(separator: "\n")
            )
            return []
        }
    }

    func configureApp(
        language: String,
        locale: String
    ) {
        sut.launchArguments = [
            "-AppleLanguages", "(\(language))",
            "-AppleLocale", "\(locale)"
        ]
    }

    func getuButton(for id: String) -> XCUIElement {
        sut.buttons[id]
    }

    func getLocalizedString(
        for key: String,
        language: String,
        locale: String
    ) -> String? {
        guard let lprojPath = testBundle.path(
            forResource: language,
            ofType: "lproj"
        ) else {
            XCTFail("Did not retrieve lproj path for \(locale)")
            return nil
        }

        guard let localizationBundle = Bundle(path: lprojPath) else {
            XCTFail("Did not retrieve localization bundle for \(language)")
            return nil
        }

        return localizationBundle.localizedString(
            forKey: key,
            value: nil,
            table: nil
        )
    }
}
