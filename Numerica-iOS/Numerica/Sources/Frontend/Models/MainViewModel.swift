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

    // TODO: - Refactor ErrorShowingView logic - mb some unused

    @Published var mode: Mode = .zen
    @Published var isGameStarted = false
    @Published var shouldShowResultsView = false

    @Published var userInput = ""
    @Published var problem: ProblemModel = .empty

    @Published var actionButtonText: String = .startButtonTitle
    @Published var remainingTime: Int = .defaultTimeInterval
    @Published var placeholderText = ""
    @Published var placeholderColor: Color = .gray
    @Published var showingError = false

    var sessionResults: [ProblemModel] {
        gameSession?.problems ?? []
    }

    private var gameSession: GameSessionModel?
    private let storageService: StorageService
    private let problemGenerator: ProblemGenerator
    private var timerManager: TimerManager?

    private var cancellables = Set<AnyCancellable>()
    private var operation: Operator {
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
            processAnswer()
            userInput.removeAll()
        case false:
            start()
        }
    }

    func onEndButtonTap() {
        end()
        guard !sessionResults.isEmpty else {
            return
        }
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
        gameSession = nil
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
        problem = .empty
        userInput.removeAll()
    }

    func processAnswer() {
        guard !userInput.isEmpty else {
            showErrorPlaceholder()
            return
        }

        guard let solution = userInput.intValue else {
            return
        }

        if solution == problem.solution {
            gameSession?.goodAnswersCount += 1
            problem.solved = true
        } else {
            gameSession?.badAnswersCount += 1
        }

        gameSession?.problems.append(problem)

        problem = problemGenerator.getProblem(for: operation)
    }

    func showErrorPlaceholder() {
        guard !showingError else {
            return
        }

        showingError = true

        withAnimation(
            .easeInOut(duration: 0.5)
        ) {
            self.placeholderText = "input number"
            self.placeholderColor = .red
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(
                .easeInOut(duration: 0.5)
            ) {
                self.placeholderText.removeAll()
                self.placeholderColor = .gray
                self.showingError = false
            }
        }
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

    static let startButtonTitle: Self = String(localized: "START")
    static let submitButtonTitle: Self = String(localized: "SUBMIT")
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
