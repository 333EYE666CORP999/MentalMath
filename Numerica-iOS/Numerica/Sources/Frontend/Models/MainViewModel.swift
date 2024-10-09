import Combine
import SwiftUI

// MARK: - MainViewModel

@MainActor
final class MainViewModel: ObservableObject {

    // TODO: - Refactor ErrorShowingView logic - mb some unused

    @Published var isGameStarted = false
    @Published var shouldShowResultsView = false

    @Published var userInput = ""
    @Published var problem: ProblemModel = .empty

    @Published var actionButtonText: String = .startButtonTitle
    @Published var placeholderText = ""
    @Published var placeholderColor: Color = .gray
    @Published var showingError = false

    var sessionResults: [ProblemModel] {
        gameSession?.problems ?? []
    }

    private var gameSession: GameSessionModel?
    private let storageService: StorageServiceInput
    private let problemGenerator: ProblemGeneratorInput

    private var operation: Operator {
        .random
    }

    init(
        storageService: StorageServiceInput,
        problemGenerator: ProblemGeneratorInput
    ) {
        self.storageService = storageService
        self.problemGenerator = problemGenerator
        self.problem = .empty
    }

    // TODO: - переписать, чтоб было две разных кнопки
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

// MARK: - Game Logic

private extension MainViewModel {

    func start() {
        gameSession = nil
        isGameStarted = true
        problem = problemGenerator.getProblem(for: operation)
        actionButtonText = .submitButtonTitle
        gameSession = GameSessionModel(sessionDate: Date())
    }

    func end() {
        guard let gameSession else {
            return
        }

        storageService.save(gameSession.convertToObject())
        actionButtonText = .startButtonTitle
        isGameStarted = false
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
        if !showingError {
            showingError = true

            withAnimation(
                .easeInOut(duration: 0.5)
            ) {
                self.placeholderText = "INPUT NUMBER".localized
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
}

// MARK: - Constants

private extension String {

    static let startButtonTitle: Self = String(localized: "START")
    static let submitButtonTitle: Self = String(localized: "SUBMIT")
}

private extension Int {

    static let defaultTimeInterval: Self = 60
}
