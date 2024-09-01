//
//  CountdownTimerView.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI

struct CountdownTimerView: View {

    @StateObject private var timerManager = TimerManager()
    @Binding var isStarted: Bool

    var body: some View {
        Text("\(timeString(from: timerManager.remainingTime))")
            .font(.system(size: 60, weight: .bold, design: .monospaced))
            .padding()
            .padding()
            .foregroundColor(.white)
            .onChange(of: isStarted) { _, newValue in
                switch newValue {
                case true: timerManager.startTimer()
                case false: timerManager.stopTimer()
                }
            }
            .onChange(of: timerManager.isTimerRunning) { _, newValue in
                isStarted = newValue
            }
    }

    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ZStack {
        Rectangle().foregroundColor(
            .black
        ).ignoresSafeArea()
        CountdownTimerView(
            isStarted: Binding<Bool>.constant(true)
        )
    }

}
