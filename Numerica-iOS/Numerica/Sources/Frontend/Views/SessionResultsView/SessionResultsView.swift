//
//  GameResultsView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation
import SwiftUI

struct SessionResultsView: View {

    var sessionResults: [ProblemModel]

    var body: some View {
        ZStack {
            VStack {
                List(sessionResults) { rowItem in
                    SessionListItem(
                        problemString: rowItem.problemString,
                        solution: rowItem.solution,
                        solved: rowItem.solved
                    )
                }
            }
        }
    }
}

// FIXME: - нужно дорабтотать, пока early prototype
struct SessionListItem: View {

    static var empty = Self(
        problemString: "",
        solution: .zero,
        solved: .random()
    )

    var problemString: String
    var solution: Int
    var solved: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            HStack(alignment: .top) {
                VStack {
                    Text("ProblemString")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("Answer")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("❌ / ✅")
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SessionResultsView(sessionResults: [])
    //    SessionListItem.empty
}
