//
//  File.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation
import Speech

final class MathGen {

    func getProblem() -> String {
        let ops = ["+", "-", "*", "/"]
        let ranges = [0...9, 10...99, 100...999]
        guard
            let op = ops.randomElement(),
            let lhsRange = ranges.randomElement(),
            let rhsRange = ranges.randomElement()
        else { return "" }

        return [
            String(Int.random(in: lhsRange)),
            " ",
            op,
            " ",
            String(Int.random(in: rhsRange))
        ].joined()

    }
}
