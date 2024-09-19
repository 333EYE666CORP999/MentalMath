//
//  ContentViewModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 02.09.2024.
//

import Combine
import SwiftUI

// MARK: - MainViewModel

final class MainViewModel: ObservableObject {

    typealias Problem = ProblemGenerator.ProblemDTO
    typealias Operation = ProblemGenerator.Operation

    @Published var userInput = ""
    @Published var problem: Problem = .empty
    @Published var actionButtonText: String = .startButtonTitle
    @Published var isGameStarted = false
    @Published var remainingTime: Int = .defaultTimeInterval
    @Published var mode: Mode = .zen
    @Published var shouldShowResultsView = false

    private var gameSession: GameSessionModel?
    private let storageService: StorageService
    private let problemGenerator: ProblemGenerator
    private var timerManager: TimerManager?

    private var cancellables = Set<AnyCancellable>()
    private var operation: Operation {
        .random
    }

    init(
        storageService: StorageService,
        mathGen: ProblemGenerator
    ) {
        self.storageService = storageService
        self.problemGenerator = ProblemGenerator()
        self.problem = mathGen.getProblem(for: operation)
    }

    func onActionButtonTap() {
        switch isGameStarted {
        case true:
            shouldShowResultsView = false
            problem = problemGenerator.getProblem(for: operation)
            userInput.removeAll()
            processAnswer()
        case false:
            start()
        }
    }

    func onEndButtonTap() {
        end()
        shouldShowResultsView = true
    }
}

// MARK: - Game Mode

extension MainViewModel {

    enum Mode {
        case zen, timed
    }
}

// MARK: - Game Logic

private extension MainViewModel {

    func start() {
        isGameStarted = true
        problem = problemGenerator.getProblem(for: operation)
        actionButtonText = .submitButtonTitle
        timerManager?.startTimer()
        gameSession = GameSessionModel(sessionDate: Date())
    }

    func end() {
        guard let gameSession else {
            return
        }

        storageService.save(gameSession.convertToObject())
        actionButtonText = .startButtonTitle
        isGameStarted = false
        remainingTime = .defaultTimeInterval
        self.gameSession = nil
        problem = .empty
        userInput.removeAll()

        #if DEBUG
        print(
            Array(
                storageService.fetch(
                    GameSessionObject.self
                )
            )
        )
        #endif
    }

    func processAnswer() {
        guard let solution = userInput.intValue else {
            return
        }

        if solution == problem.solution {
            gameSession?.goodAnswersCount += 1
            problem.solved = true
        } else {
            gameSession?.badAnswersCount += 1
        }

        gameSession?.problems.append(
            ProblemModel(
                problem: problem.problemString,
                solution: problem.solution,
                solved: problem.solved
            )
        )
    }
}

// MARK: - Private Methods

private extension MainViewModel {

    func setupTimerIfNeeded() {
        guard mode != .zen else {
            return
        }
        timerManager = TimerManager()
        bindTimer()
    }

    func bindTimer() {
        timerManager?.$remainingTime
            .assign(to: \.remainingTime, on: self)
            .store(in: &cancellables)
        timerManager?.timerEndSubject
            .sink { [weak self] in self?.end() }
            .store(in: &cancellables)
    }
}

// MARK: - Constants

private extension String {

    static let startButtonTitle: Self = "START"
    static let submitButtonTitle: Self = "SUBMIT"
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
