//
//  GameResultsView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation
import SwiftUI

struct SessionResultsView: View {

    @Binding var shouldShowSessionResultsView: Bool

    var sessionResults: [ProblemModel]

    var body: some View {
        ZStack {
            Self.semanticBackground
            VStack {
                Spacer()
                List(sessionResults) { rowItem in
                    SessionResultsListItem(
                        problemString: rowItem.problemString,
                        solution: rowItem.solution,
                        solved: rowItem.solved
                    )
                }
            }
        }
        .onDisappear {
            shouldShowSessionResultsView = false
        }
    }
}
