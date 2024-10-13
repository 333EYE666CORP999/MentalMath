import Foundation

@MainActor
enum Operator: String, CaseIterable, Codable {

    case addition = "+"
    case subtraction = "-"
    case multiplication = "*"
    case division = "/"

    static var random: Self {
        Self.allCases[Int.random(
            in: 0..<Self.allCases.count,
            using: &ProblemGenerator.rng
        )]
    }
}
