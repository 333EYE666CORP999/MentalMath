//
//  GameResultsView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation
import SwiftUI

struct SessionResultsView: View {

    struct DataKKK: Identifiable {
        var id = UUID()

        var date: Date
        var total: Int
        var good: Int
        var bad: Int
        var rate: Double
    }

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
                Text("SESSION RESULTS")
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                List(data, id: \.id) { rowItem in
                    SessionListItem(
                        date: rowItem.date,
                        answersCount: rowItem.total,
                        goodAnswersCount: rowItem.good,
                        badAnswersCount: rowItem.bad,
                        winrate: rowItem.rate
                    )
                }
                .foregroundColor(.black)
                .ignoresSafeArea()
            }
        }
    }
}

struct SessionListItem: View {

    var date: Date
    var answersCount: Int
    var goodAnswersCount: Int
    var badAnswersCount: Int
    var winrate: Double

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            HStack(alignment: .top) {
                VStack {
                    Text("DATE")
                        .foregroundStyle(.white)
                    Text("2024-09-13")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("ANSWERS")
                        .foregroundStyle(.white)
                    Text("666")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("GOOD")
                        .foregroundStyle(.white)
                    Text("333")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("BAD")
                        .foregroundStyle(.white)
                    Text("333")
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text("WINRATE")
                        .foregroundStyle(.white)
                    Text("50%")
                        .foregroundStyle(.white)
                }

            }
        }
    }

    static var empty: Self = Self(
        date: Date(),
        answersCount: .zero,
        goodAnswersCount: .zero,
        badAnswersCount: .zero,
        winrate: .zero
    )
}

#Preview {
    SessionResultsView()
//    SessionListItem.empty
}
