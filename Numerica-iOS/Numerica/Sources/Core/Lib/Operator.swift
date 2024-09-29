import Foundation

@MainActor
enum Operator: String, CaseIterable, Codable {

    case addition = "+"
    case subtraction = "-"
    case multiplication = "*"
    case division = "/"

    static var random: Self {
        guard
            let random = Self.allCases.randomElement(
                using: &ProblemGenerator.rng
            )
        else {
            return .subtraction
        }

        return random
    }
}
