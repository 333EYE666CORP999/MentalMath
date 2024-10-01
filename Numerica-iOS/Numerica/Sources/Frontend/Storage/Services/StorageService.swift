import Foundation
import SwiftData

final class StorageService: Sendable {
    private let modelActor: ModelActor

    init(container: ModelContainer) {
        self.modelActor = ModelActor(modelContainer: container)
    }

    func save<T: PersistentModel & Sendable>(_ model: T) {
        Task { @Sendable [weak self] in
            guard let self else {
                return
            }
            await modelActor.saveModel(model)
        }
    }
}

@ModelActor
actor ModelActor {

    typealias SendablePersistentEntity = PersistentModel & Sendable

    func saveModel<T: PersistentModel>(_ model: T) async {
        modelContext.insert(model)
        do {
            try modelContext.save()
        } catch {
            print("Error saving model: \(error.localizedDescription)")
        }
    }
}