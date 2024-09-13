//
//  ContentView.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI
import Foundation

struct GameView: View {

    @EnvironmentObject var viewModel: GameViewModel
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            background
            endGameButtonView

            switch viewModel.mode {
            case .zen:
                zenGameView
            case .timed:
                timedGameView
            }
        }
    }

    var zenGameView: some  View {
        VStack {
            if viewModel.isGameStarted {
                problemView
                inputTextField
            }
            actionButton
        }
    }

    var timedGameView: some View {
        VStack {
            if viewModel.isGameStarted {
                countdown
                problemView
                inputTextField
            }
            actionButton
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
        Text(viewModel.problem.problemString)
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
            .onAppear {
                isTextFieldFocused = true
            }
    }

    var actionButton: some View {
        ActionButton(
            title: $viewModel.actionButtonText,
            action: viewModel.onActionButtonTap
        )
    }

    var endGameButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button(
                    "✋🏻",
                    action: viewModel.onEndButtonTap
                )
                .font(.basic)
            }
            Spacer()
        }
    }
}

#Preview {
    GameView()
        .environmentObject(
            GameViewModel(
                storageService: StorageService(
                    modelContext: sharedModelContainer.mainContext
                ),
                mathGen: ProblemGenerator()
            )
        )
}
