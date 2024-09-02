//
//  ContentViewModel.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 02.09.2024.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {

    @Published var userInput: String = ""
    @Published var problem: String
    @Published var actionButtonText: String = .startButtonTitle
    @Published var isGameStarted: Bool = false
    @Published var remainingTime: Int = .defaultTimeInterval
    @Published var isTimerRunning: Bool = false

    // FIXME: - подумать, надо ли это
#warning("изучить вызовы комбайна")
    private var cancellables: Set<AnyCancellable> = []

    private var gameSession: GameSession?
    private let storageService: StorageService
    private let mathGen: MathGen
    private var timerManager: TimerManager


    init(
        storageService: StorageService,
        mathGen: MathGen
    ) {
        self.storageService = storageService
        self.mathGen = MathGen()
        self.problem = mathGen.getProblem()
        self.timerManager = TimerManager()
        bindTimer()
    }

    // FIXME: - тут нужно объединить всю логику обработки инпута после нажатия submit / start
    func onButtonTap() {
        switch isGameStarted {
        case true:
            userInput.removeAll()
            updateProblem()
        case false:
            start()
        }
    }

    // FIXME: - private?
    func updateProblem() {
        problem = mathGen.getProblem()
    }

    // FIXME: - обрабатывать ответ внутри
    func process(answer: String) {
        if answer.isNumeric {
            userInput = answer
        }
    }

    // FIXME: - private?
    func start() {
        isGameStarted = true
        problem = mathGen.getProblem()
        actionButtonText = .submitButtonTitle
        timerManager.startTimer()
    }

    // FIXME: - private?
    func end() {
        isGameStarted = false
        actionButtonText = .startButtonTitle
        problem.removeAll()
        remainingTime = .defaultTimeInterval

        // FIXME: - Убрать потом, это дебажный код
        do {
            gameSession = GameSession(
                sessionDate: Date(),
                goodAnswersCount: Int.random(in: 0...10),
                badAnswersCount: Int.random(in: 0...10)
            )
            if let gameSession {
                storageService.save(gameSession)
            }
            gameSession = nil
            print(storageService.fetch(GameSession.self).map { $0.sessionDate })
        }
    }

    #warning("изучить вызовы комбайна")
    private func bindTimer() {
        timerManager.$remainingTime
            .assign(to: \.remainingTime, on: self)
            .store(in: &cancellables)
        timerManager.$isTimerRunning
            .assign(to: \.isTimerRunning, on: self)
            .store(in: &cancellables)
        timerManager.onTimerEnd = { self.end() }
    }
}

private extension String {

    static let startButtonTitle: Self = "START"
    static let submitButtonTitle: Self = "SUBMIT"
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
