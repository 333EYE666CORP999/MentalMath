//
//  ContentView.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @State private var userInput: String = ""
    @State private var problem: String = MathGen().getProblem()
    @FocusState private var isTextFieldFocused: Bool

    private var getProblem = MathGen().getProblem

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack {
                CountdownTimerView()
                Text(problem)
                    .foregroundStyle(.white)
                    .font(
                        .system(
                            size: 60,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                TextField("input", text: $userInput)
                    .padding()
                    .font(.system(size: 50, design: .rounded))
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
