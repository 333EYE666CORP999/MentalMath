//
//  Operation.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 19.09.2024.
//

import Foundation

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
