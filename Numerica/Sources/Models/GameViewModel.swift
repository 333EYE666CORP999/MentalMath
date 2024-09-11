//
//  ContentViewModel.swift
//  Numerica
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

    private var cancellables = Set<AnyCancellable>()

    private var gameSession: GameSession?
    private let storageService: StorageService
    private let mathGen: ProblemGenerator


    init(
        storageService: StorageService,
        mathGen: ProblemGenerator
    ) {
        self.storageService = storageService
        self.timerManager = TimerManager()
        bindTimer()
        self.mathGen = ProblemGenerator()
        // TODO: - переписать, чтоб целый объект отдавался
        self.problem = mathGen.getProblem().problemString
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

    private func updateProblem() {
        problem = mathGen.getProblem()
    }

    func process(answer: String) {
        if answer.isNumeric {
            userInput = answer
        }
    }

    private func start() {
        problem = mathGen.getProblem()
        actionButtonText = .submitButtonTitle
        isGameStarted = true
        timerManager.startTimer()
    }

    private func end() {
        problem.removeAll()
        actionButtonText = .startButtonTitle
        isGameStarted = false
        remainingTime = .defaultTimeInterval

        // FIXME: - Убрать потом, это дебажный код (на этапе логики игры)
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

    private func bindTimer() {
        timerManager.$remainingTime
            .assign(to: \.remainingTime, on: self)
            .store(in: &cancellables)
        timerManager.timerEndSubject
            .sink { [weak self] in self?.end() }
            .store(in: &cancellables)
    }
}

private extension String {

    static let startButtonTitle: Self = "START"
    static let submitButtonTitle: Self = "SUBMIT"
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
