import Foundation
import SwiftUI

struct MainView: View {

    @EnvironmentObject var viewModel: MainViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Self.semanticBackground

                if viewModel.isGameStarted {
                    endGameButtonView
                }

                zenMainView
            }
            .navigationDestination(
                for: String.self
            ) {
                if $0 == "SessionResultsView" {
                    SessionResultsView(
                        shouldShowSessionResultsView: $viewModel.shouldShowResultsView,
                        sessionResults: viewModel.sessionResults
                    )
                    .navigationTitle("SESSION RESULTS")
                    .accessibilityIdentifier("SessionResults.View")
                }
            }
            .onChange(
                of: viewModel.shouldShowResultsView
            ) { _, newValue in
                if newValue {
                    navigationPath.append("SessionResultsView")
                }
            }
        }
    }

    var zenMainView: some  View {
        VStack {
            if viewModel.isGameStarted {
                problemView
                inputTextField
            }
            actionButton
        }
    }

    var problemView: some View {
        Text(viewModel.problem.problemString)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .font(.primary)
            .accessibilityIdentifier(
                "MainView.ProblemView"
            )
    }

    var inputTextField: some View {
        ErrorShowingTextField(
            text: $viewModel.userInput,
            placeholderText: $viewModel.placeholderText,
            placeholderColor: $viewModel.placeholderColor
        )
        .padding()
        .font(.primary)
        .foregroundStyle(.white)
        .keyboardType(.numberPad)
        .multilineTextAlignment(.center)
        .focused($isTextFieldFocused)
        .onAppear {
            isTextFieldFocused = true
        }
    }

    var actionButton: some View {
        ActionButton(
            title: $viewModel.actionButtonText,
            action: viewModel.onActionButtonTap
        )
        .accessibilityIdentifier(
            "MainView.ActionButton"
        )
    }

    var endGameButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button(
                    "STOP",
                    action: viewModel.onEndButtonTap
                )
                .foregroundStyle(.white)
                .font(.secondary)
                .accessibilityIdentifier(
                    "MainView.EndButton"
                )
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
//        .environmentObject(
//            MainViewModel(
//                storageService: StorageService(
//                    modelContext: sharedModelContainer.mainContext
//                ),
//                problemGenerator: ProblemGenerator()
//            )
//        )
}
