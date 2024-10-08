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

    var doubleValue: Double {
        Double(self)
    }
}

extension String {

    static let minutesSecondsFormat: Self = "%02d:%02d"

    var intValue: Int? {
        Int(self)
    }
}

extension Character {

    static let space: Self = " "
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

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
