//
//  Problem.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 11.09.2024.
//

import Foundation
import SwiftData

@Model
final class Problem {

    var id = UUID()

    var problem: String
    var solution: Int

    init(problem: String, solution: Int) {
        self.problem = problem
        self.solution = solution
    }
}
