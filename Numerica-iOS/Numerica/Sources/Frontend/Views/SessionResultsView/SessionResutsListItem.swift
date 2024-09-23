import Foundation
import SwiftUI

// FIXME: - нужно дорабтотать, пока early prototype
struct SessionResultsListItem: View {

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
            HStack(alignment: .top) {
                VStack {
                    Text(problemString)
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text(solution.stringValue)
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack {
                    Text(solved ? "✅" : "❌")
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SessionResultsView(
        shouldShowSessionResultsView: Binding<Bool>.constant(true),
        sessionResults: [
            ProblemModel(
                lhs: 0,
                operation: .division,
                rhs: 0,
                solution: 0
            )
        ]
    )
}

