//
//  TimerManager.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation
import Combine

final class TimerManager: ObservableObject {

    @Published var isTimerRunning: Bool = false
    @Published var remainingTime: Int = .defaultRemainingTime

    private var timerSubscription: Cancellable?

    func startTimer() {
        remainingTime = .defaultRemainingTime
        isTimerRunning = true
        timerSubscription = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
            }
        }
    }

    func stopTimer() {
        isTimerRunning = false
        timerSubscription?.cancel()
        timerSubscription = nil
    }
}

private extension Int {
    static let defaultRemainingTime: Self = 60
}
