import Foundation

extension Int {

    static let zero: Self = 0

    var stringValue: String {
        String(self)
    }

    var doubleValue: Double {
        Double(self)
    }
}

extension String {

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

extension Double {

    var intValue: Int {
        Int(self)
    }
}
