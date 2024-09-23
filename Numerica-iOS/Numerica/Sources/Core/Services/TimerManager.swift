//
//  TimerManager.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 01.09.2024.
//

import Combine
import Foundation

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
            guard let self else {
                return
            }
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
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
