//
//  ContentView.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI

struct ContentView: View {

    @FocusState private var isTextFieldFocused: Bool
    @State private var userInput: String = ""
    @State private var problem: String = MathGen().getProblem()
    @State private var actionButtonText: String = "START"
    @State private var isTimerStarted: Bool = false {
        didSet(newValue) {
            print(newValue)
        }
    }

    private var getProblem = MathGen().getProblem
    private let font: Font = .system(
        size: 60,
        weight: .bold,
        design: .monospaced
    )

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack {
                CountdownTimerView(
                    isStarted: $isTimerStarted
                )
                Text(problem)
                    .foregroundStyle(.white)
                    .font(font)
                TextField("input", text: $userInput)
                    .padding()
                    .font(font)
                    .foregroundStyle(.white)
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .onChange(of: userInput) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if newValue != filtered {
                            userInput = filtered
                        }
                    }
                    .onAppear {
                        isTextFieldFocused = true
                    }
                Button(
                    isTimerStarted ? "SUBMIT" : "START"
                ) {
                    switch isTimerStarted {
                    case true:
                        print(userInput)
                        userInput.removeAll()
                        problem = getProblem()
                    case false:
                        isTimerStarted = true
                    }
                }
                .font(font)
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ContentView()
}
