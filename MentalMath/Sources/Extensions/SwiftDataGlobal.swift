//
//  Previews.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 04.09.2024.
//

import Foundation
import SwiftData

#warning("Global scope variable, use ONLY for previews")
var sharedModelContainer: ModelContainer = {
    let schema = Schema([GameSession.self])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )

    do {
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
