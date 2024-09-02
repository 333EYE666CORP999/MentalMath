//
//  ContentView.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI
import SwiftData

struct GameView: View {

    @EnvironmentObject var viewModel: GameViewModel

    // FIXME: - перетащить в модель
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            background
            VStack {
                if viewModel.isGameStarted {
                    countdown
                    problemView
                    inputTextField
                }
                actionButton
            }
        }
    }

    var background: some View {
        Rectangle()
            .foregroundColor(.black)
            .ignoresSafeArea()
    }

    var countdown: some View {
        CountdownTimerView(
            remainingTime: $viewModel.remainingTime
        )
    }

    var problemView: some View {
        Text(viewModel.problem)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .font(.basic)
    }

    var inputTextField: some View {
        TextField("input", text: $viewModel.userInput)
            .padding()
            .font(.basic)
            .foregroundStyle(.white)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .focused($isTextFieldFocused)

        // FIXME: - перетащить в модель
            .onChange(of: viewModel.userInput) {
                viewModel.process(answer: $1)
            }

        // FIXME: - перетащить в модель
            .onAppear {
                isTextFieldFocused = true
            }
    }

    var actionButton: some View {
        ActionButton(
            title: $viewModel.actionButtonText,
            action: viewModel.onButtonTap
        )
    }
}

#Preview {
    GameView()
        .environmentObject(
            GameViewModel(
                storageService: StorageService(
                    modelContext: sharedModelContainer.mainContext
                ),
                mathGen: MathGen()
            )
        )
}
