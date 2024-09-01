//
//  ContentView.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI

struct ContentView: View {

    @State private var userInput: String = ""
    @State private var problem: String = MathGen().getProblem()
    @FocusState private var isTextFieldFocused: Bool

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
                CountdownTimerView()
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
                Button("Submit") {
                    print(userInput)
                    userInput.removeAll()
                    problem = getProblem()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
