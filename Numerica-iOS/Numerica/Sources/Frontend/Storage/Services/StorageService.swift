import Foundation
import SwiftData

protocol StorageServiceInput {

    func save<T: PersistentModel>(_ model: T)
}

final class StorageService {

    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

extension StorageService: StorageServiceInput {

    typealias Object = PersistentModel & PersistentObject

    func save<T: PersistentModel>(_ model: T) {
        do {
            modelContext.insert(model)
            try modelContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
