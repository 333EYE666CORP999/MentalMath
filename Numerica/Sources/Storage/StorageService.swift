//
//  StorageService.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 02.09.2024.
//

import Foundation
import SwiftData

final class StorageService {

    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save<T: PersistentModel>(_ model: T) {
        do {
            modelContext.insert(model)
            try modelContext.save()
        } catch let error as NSError {
            print(error)
        }
    }

    func fetch<T: PersistentModel>(_ type: T.Type) -> [T] {
        let desc = FetchDescriptor<T>()
        var all = [T]()

        do {
            all = try modelContext.fetch(desc)
        } catch let error as NSError {
            print(error)
        }

        return all
    }
}
