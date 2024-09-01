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
    @State private var areOverlayViewsHidden = true
    @FocusState private var isTextFieldFocused: Bool
    @State private var problem: String = MathGen().getProblem()

    private var getProblem = MathGen().getProblem

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Text(problem)
                .foregroundStyle(.gray)
                .font(.system(size: 50, design: .rounded))
                .opacity(areOverlayViewsHidden ? 1 : 0)
                .onTapGesture {
                    areOverlayViewsHidden = false
                    isTextFieldFocused = true
                }

            VStack {
                TextField("input", text: $userInput)
                    .padding()
                    .font(.system(size: 50, design: .rounded))
                    .foregroundStyle(.white)
                    .focused($isTextFieldFocused)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .opacity(areOverlayViewsHidden ? 0 : 1)
                    .onChange(of: userInput) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if newValue != filtered {
                            userInput = filtered
                        }
                    }
                Button("Submit") {
                    print(userInput)
                    areOverlayViewsHidden = true
                    userInput.removeAll()
                    problem = getProblem()
                }
                .opacity(areOverlayViewsHidden ? 0 : 1)
            }
        }
    }
}

#Preview {
    ContentView()
}
