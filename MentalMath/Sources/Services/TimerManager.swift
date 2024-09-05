//
//  TimerManager.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Foundation
import Combine

final class TimerManager: ObservableObject {

    @Published var remainingTime: Int = .defaultRemainingTime

    let timerEndSubject = PassthroughSubject<Void, Never>()
    private var timerSubscription: Cancellable?

    func startTimer() {
        remainingTime = .defaultRemainingTime
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
        timerSubscription?.cancel()
        timerSubscription = nil
        timerEndSubject.send(())
    }
}

private extension Int {
    static let defaultRemainingTime: Self = 6
}
