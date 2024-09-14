//
//  Foundation.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 02.09.2024.
//

import Foundation

extension Int {

    static let zero: Self = 0
    static let secondsInMunute: Self = 60

    var timeStringFromSeconds: String {
        String(
            format: .minutesSecondsFormat,
            self / .secondsInMunute,
            self % .secondsInMunute
        )
    }

    var stringValue: String {
        String(self)
    }
}

extension String {

    var isNumeric: Bool {
        self.allSatisfy { $0.isNumber }
    }

    var intValue: Int? {
        Int(self)
    }

    static var minutesSecondsFormat: Self = "%02d:%02d"
    static var space: Self = " "
}

extension Character {

    static var space: Self = " "
}

extension DateFormatter {

    static let dateTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY, HH:mm:ss"
        return formatter
    }()
}

extension Decimal {

    var intValue: Int {
        NSDecimalNumber(
            decimal: self
        ).rounding(
            accordingToBehavior: nil
        ).intValue
    }
}

extension Double {

    var intValue: Int { Int(self) }
}