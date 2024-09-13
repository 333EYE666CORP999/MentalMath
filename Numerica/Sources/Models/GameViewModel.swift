//
//  ContentViewModel.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 02.09.2024.
//

import SwiftUI
import Combine

// MARK: - GameViewModel

final class GameViewModel: ObservableObject {

    @Published var userInput: String = ""
    @Published var problem: ProblemGenerator.ProblemDTO = .empty
    @Published var actionButtonText: String = .startButtonTitle
    @Published var isGameStarted: Bool = false
    @Published var remainingTime: Int = .defaultTimeInterval
    @Published var mode: Mode = .zen

    private var cancellables = Set<AnyCancellable>()

    private var gameSession: GameSessionModel?
    private let storageService: StorageService
    private let mathGen: ProblemGenerator
    private var timerManager: TimerManager?

    init(
        storageService: StorageService,
        mathGen: ProblemGenerator
    ) {
        self.storageService = storageService
        self.mathGen = ProblemGenerator()
        self.problem = mathGen.getProblem()
    }

    func onActionButtonTap() {
        switch isGameStarted {
        case true:
            processAnswer()
            updateProblem()
            userInput.removeAll()
        case false:
            start()
        }
    }

    func onEndButtonTap() {
        end()
    }
}

// MARK: - Game Mode

extension GameViewModel {

    enum Mode {
        case zen, timed
    }
}

// MARK: - Private

private extension GameViewModel {

    func setup() {
        guard mode != .zen else {
            return
        }
        timerManager = TimerManager()
        bindTimer()
    }

    func start() {
        problem = mathGen.getProblem()
        gameSession = GameSessionModel(sessionDate: Date())
        actionButtonText = .submitButtonTitle
        isGameStarted = true
        timerManager?.startTimer()
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
        self.problem = .empty
        userInput.removeAll()

        let xddd = storageService.fetch(GameSessionObject.self).map { $0 }
        print(xddd)
    }

    func updateProblem() {
        problem = mathGen.getProblem()
    }

    func bindTimer() {
        timerManager?.$remainingTime
            .assign(to: \.remainingTime, on: self)
            .store(in: &cancellables)
        timerManager?.timerEndSubject
            .sink { [weak self] in self?.end() }
            .store(in: &cancellables)
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

// MARK: - Constants

private extension String {

    static let startButtonTitle: Self = "START"
    static let submitButtonTitle: Self = "SUBMIT"
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
