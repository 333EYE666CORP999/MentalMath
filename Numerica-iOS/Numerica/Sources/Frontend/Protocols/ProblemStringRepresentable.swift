//
//  ProblemStringRepresentable.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 19.09.2024.
//

import Foundation

// TODO: - перенести на уровень коры
protocol ProblemStringRepresentable {

    var lhs: Int { get }
    var `operator`: Operator { get }
    var rhs: Int { get }

    var problemString: String { get }
}

extension ProblemStringRepresentable {

    var problemString: String {
        [
            lhs.stringValue,
            `operator`.rawValue,
            rhs.stringValue
        ].joined(separator: " ")
    }
}
