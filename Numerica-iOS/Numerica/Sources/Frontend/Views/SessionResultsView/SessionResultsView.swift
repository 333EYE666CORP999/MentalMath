//
//  GameResultsView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation
import SwiftUI

struct SessionResultsView: View {

    // FIXME: - убрать после того, как закончим экран статы сессии
    struct DataKKK: Identifiable {
        var id = UUID()

        var date: Date
        var total: Int
        var good: Int
        var bad: Int
        var rate: Double
    }

    // FIXME: - убрать после того, как закончим экран статы сессии
    let data = Array(
        repeating: DataKKK(
            date: Date(),
            total: 22,
            good: 10,
            bad: 12,
            rate: 2.9
        ),
        count: 25
    )

    var body: some View {
        ZStack {
            VStack {
                List(data, id: \.id) { rowItem in
                    SessionListItem.empty
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
    SessionResultsView()
    //    SessionListItem.empty
}
